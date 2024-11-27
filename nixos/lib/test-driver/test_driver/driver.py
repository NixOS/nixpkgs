import os
import re
import signal
import tempfile
import threading
from collections.abc import Callable, Iterator
from contextlib import AbstractContextManager, contextmanager
from pathlib import Path
from typing import Any

from colorama import Fore, Style

from test_driver.logger import AbstractLogger
from test_driver.machine import Machine, NixStartScript, retry
from test_driver.polling_condition import PollingCondition
from test_driver.vlan import VLan

SENTINEL = object()


def get_tmp_dir() -> Path:
    """Returns a temporary directory that is defined by TMPDIR, TEMP, TMP or CWD
    Raises an exception in case the retrieved temporary directory is not writeable
    See https://docs.python.org/3/library/tempfile.html#tempfile.gettempdir
    """
    tmp_dir = Path(tempfile.gettempdir())
    tmp_dir.mkdir(mode=0o700, exist_ok=True)
    if not tmp_dir.is_dir():
        raise NotADirectoryError(
            f"The directory defined by TMPDIR, TEMP, TMP or CWD: {tmp_dir} is not a directory"
        )
    if not os.access(tmp_dir, os.W_OK):
        raise PermissionError(
            f"The directory defined by TMPDIR, TEMP, TMP, or CWD: {tmp_dir} is not writeable"
        )
    return tmp_dir


def pythonize_name(name: str) -> str:
    return re.sub(r"^[^A-z_]|[^A-z0-9_]", "_", name)


class Driver:
    """A handle to the driver that sets up the environment
    and runs the tests"""

    tests: str
    vlans: list[VLan]
    machines: list[Machine]
    polling_conditions: list[PollingCondition]
    global_timeout: int
    race_timer: threading.Timer
    logger: AbstractLogger

    def __init__(
        self,
        start_scripts: list[str],
        vlans: list[int],
        tests: str,
        out_dir: Path,
        logger: AbstractLogger,
        keep_vm_state: bool = False,
        global_timeout: int = 24 * 60 * 60 * 7,
    ):
        self.tests = tests
        self.out_dir = out_dir
        self.global_timeout = global_timeout
        self.race_timer = threading.Timer(global_timeout, self.terminate_test)
        self.logger = logger

        tmp_dir = get_tmp_dir()

        with self.logger.nested("start all VLans"):
            vlans = list(set(vlans))
            self.vlans = [VLan(nr, tmp_dir, self.logger) for nr in vlans]

        def cmd(scripts: list[str]) -> Iterator[NixStartScript]:
            for s in scripts:
                yield NixStartScript(s)

        self.polling_conditions = []

        self.machines = [
            Machine(
                start_command=cmd,
                keep_vm_state=keep_vm_state,
                name=cmd.machine_name,
                tmp_dir=tmp_dir,
                callbacks=[self.check_polling_conditions],
                out_dir=self.out_dir,
                logger=self.logger,
            )
            for cmd in cmd(start_scripts)
        ]

    def __enter__(self) -> "Driver":
        return self

    def __exit__(self, *_: Any) -> None:
        with self.logger.nested("cleanup"):
            self.race_timer.cancel()
            for machine in self.machines:
                try:
                    machine.release()
                except Exception as e:
                    self.logger.error(f"Error during cleanup of {machine.name}: {e}")

            for vlan in self.vlans:
                try:
                    vlan.stop()
                except Exception as e:
                    self.logger.error(f"Error during cleanup of vlan{vlan.nr}: {e}")

    def subtest(self, name: str) -> Iterator[None]:
        """Group logs under a given test name"""
        with self.logger.subtest(name):
            try:
                yield
            except Exception as e:
                self.logger.error(f'Test "{name}" failed with error: "{e}"')
                raise e

    def test_symbols(self) -> dict[str, Any]:
        @contextmanager
        def subtest(name: str) -> Iterator[None]:
            return self.subtest(name)

        general_symbols = dict(
            start_all=self.start_all,
            test_script=self.test_script,
            machines=self.machines,
            vlans=self.vlans,
            driver=self,
            log=self.logger,
            os=os,
            create_machine=self.create_machine,
            subtest=subtest,
            run_tests=self.run_tests,
            join_all=self.join_all,
            retry=retry,
            serial_stdout_off=self.serial_stdout_off,
            serial_stdout_on=self.serial_stdout_on,
            polling_condition=self.polling_condition,
            Machine=Machine,  # for typing
        )
        machine_symbols = {pythonize_name(m.name): m for m in self.machines}
        # If there's exactly one machine, make it available under the name
        # "machine", even if it's not called that.
        if len(self.machines) == 1:
            (machine_symbols["machine"],) = self.machines
        vlan_symbols = {
            f"vlan{v.nr}": self.vlans[idx] for idx, v in enumerate(self.vlans)
        }
        print(
            "additionally exposed symbols:\n    "
            + ", ".join(map(lambda m: m.name, self.machines))
            + ",\n    "
            + ", ".join(map(lambda v: f"vlan{v.nr}", self.vlans))
            + ",\n    "
            + ", ".join(list(general_symbols.keys()))
        )
        return {**general_symbols, **machine_symbols, **vlan_symbols}

    def test_script(self) -> None:
        """Run the test script"""
        with self.logger.nested("run the VM test script"):
            symbols = self.test_symbols()  # call eagerly
            exec(self.tests, symbols, None)

    def run_tests(self) -> None:
        """Run the test script (for non-interactive test runs)"""
        self.logger.info(
            f"Test will time out and terminate in {self.global_timeout} seconds"
        )
        self.race_timer.start()
        self.test_script()
        # TODO: Collect coverage data
        for machine in self.machines:
            if machine.is_up():
                machine.execute("sync")

    def start_all(self) -> None:
        """Start all machines"""
        with self.logger.nested("start all VMs"):
            for machine in self.machines:
                machine.start()

    def join_all(self) -> None:
        """Wait for all machines to shut down"""
        with self.logger.nested("wait for all VMs to finish"):
            for machine in self.machines:
                machine.wait_for_shutdown()
            self.race_timer.cancel()

    def terminate_test(self) -> None:
        # This will be usually running in another thread than
        # the thread actually executing the test script.
        with self.logger.nested("timeout reached; test terminating..."):
            for machine in self.machines:
                machine.release()
            # As we cannot `sys.exit` from another thread
            # We can at least force the main thread to get SIGTERM'ed.
            # This will prevent any user who caught all the exceptions
            # to swallow them and prevent itself from terminating.
            os.kill(os.getpid(), signal.SIGTERM)

    def create_machine(
        self,
        start_command: str | dict,
        *,
        name: str | None = None,
        keep_vm_state: bool = False,
    ) -> Machine:
        # Legacy args handling
        # FIXME: remove after 24.05
        if isinstance(start_command, dict):
            if name is not None or keep_vm_state:
                raise TypeError(
                    "Dictionary passed to create_machine must be the only argument"
                )

            args = start_command
            start_command = args.pop("startCommand", SENTINEL)

            if start_command is SENTINEL:
                raise TypeError(
                    "Dictionary passed to create_machine must contain startCommand"
                )

            if not isinstance(start_command, str):
                raise TypeError(
                    f"startCommand must be a string, got: {repr(start_command)}"
                )

            name = args.pop("name", None)
            keep_vm_state = args.pop("keep_vm_state", False)

            if args:
                raise TypeError(
                    f"Unsupported arguments passed to create_machine: {args}"
                )

            self.logger.warning(
                Fore.YELLOW
                + Style.BRIGHT
                + "WARNING: Using create_machine with a single dictionary argument is deprecated and will be removed in NixOS 24.11"
                + Style.RESET_ALL
            )
        # End legacy args handling

        tmp_dir = get_tmp_dir()

        cmd = NixStartScript(start_command)
        name = name or cmd.machine_name

        return Machine(
            tmp_dir=tmp_dir,
            out_dir=self.out_dir,
            start_command=cmd,
            name=name,
            keep_vm_state=keep_vm_state,
            logger=self.logger,
        )

    def serial_stdout_on(self) -> None:
        self.logger.print_serial_logs(True)

    def serial_stdout_off(self) -> None:
        self.logger.print_serial_logs(False)

    def check_polling_conditions(self) -> None:
        for condition in self.polling_conditions:
            condition.maybe_raise()

    def polling_condition(
        self,
        fun_: Callable | None = None,
        *,
        seconds_interval: float = 2.0,
        description: str | None = None,
    ) -> Callable[[Callable], AbstractContextManager] | AbstractContextManager:
        driver = self

        class Poll:
            def __init__(self, fun: Callable):
                self.condition = PollingCondition(
                    fun,
                    driver.logger,
                    seconds_interval,
                    description,
                )

            def __enter__(self) -> None:
                driver.polling_conditions.append(self.condition)

            def __exit__(self, a, b, c) -> None:  # type: ignore
                res = driver.polling_conditions.pop()
                assert res is self.condition

            def wait(self, timeout: int = 900) -> None:
                def condition(last: bool) -> bool:
                    if last:
                        driver.logger.info(
                            f"Last chance for {self.condition.description}"
                        )
                    ret = self.condition.check(force=True)
                    if not ret and not last:
                        driver.logger.info(
                            f"({self.condition.description} failure not fatal yet)"
                        )
                    return ret

                with driver.logger.nested(f"waiting for {self.condition.description}"):
                    retry(condition, timeout=timeout)

        if fun_ is None:
            return Poll
        else:
            return Poll(fun_)
