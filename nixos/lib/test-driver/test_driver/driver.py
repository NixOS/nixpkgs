import inspect
import os
import re
import signal
import subprocess
import sys
import tempfile
import threading
from collections.abc import Callable, Iterator
from contextlib import AbstractContextManager, contextmanager
from pathlib import Path
from typing import Any

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
    rebuild_cmd: Optional[str]
    rebuild_exe: Optional[str]

    def __init__(
        self,
        start_scripts: list[str],
        vlans: list[int],
        tests: str,
        out_dir: Path,
        logger: AbstractLogger,
        keep_vm_state: bool = False,
        global_timeout: int = 24 * 60 * 60 * 7,
        rebuild_cmd: Optional[str] = None,
        rebuild_exe: Optional[str] = None,
    ):
        self.tests = tests
        self.out_dir = out_dir
        self.global_timeout = global_timeout
        self.race_timer = threading.Timer(global_timeout, self.terminate_test)
        self.logger = logger
        self.rebuild_cmd = rebuild_cmd
        self.rebuild_exe = rebuild_exe

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

    def rebuild(self, cmd: Optional[str] = None, exe: Optional[str] = None) -> None:
        """
        Only makes sense when running interactively. Rebuilds the test driver by running `cmd`, or a globally defined `driver.rebuild_cmd`. This should be the same command that built this test driver to begin with. Then uses the new driver at path `exe` to reconfigure this one and redeploy changed machines.
        """

        # Get the caller module's global scope. Should be the interactive repl.
        current_frame = inspect.currentframe()
        assert current_frame is not None
        repl_frame = current_frame.f_back
        assert repl_frame is not None
        repl_globals = repl_frame.f_globals

        if cmd is None:
            cmd = self.rebuild_cmd
        if cmd is not None:
            with self.logger.nested(f"rebuilding test with `{cmd}`"):
                subprocess.run(cmd, shell=True, check=True, stdout=sys.stderr.buffer)

        tmp_dir = get_tmp_dir()

        if exe is None:
            exe = self.rebuild_exe
        if exe is None:
            # TODO: ideally Driver.rebuild_exe this could default to
            # sys.argv[0], and this would be result/ bin/nixos-test-driver in
            # the typical case, but propagating argv0 through layers of wrappers
            # does not work with python scripts. See issues #24525 #60260
            # #150841
            self.logger.error(
                'No executable name to update from. Try passing rebuild(exe="./result/bin/nixos-test-driver")'
            )
            return

        with self.logger.nested(f"getting new driver info from {exe}"):
            new_driver_info = subprocess.check_output(
                [exe, "--internal-print-update-driver-info-and-exit"],
                text=True,
            )
            (
                start_scripts,
                vlans_str,
                testscript,
                output_directory,
            ) = new_driver_info.rstrip().split("\n")

        with self.logger.nested("updating machines"):
            start_cmds = [
                NixStartScript(start_script) for start_script in start_scripts.split()
            ]
            names = [start_cmd.machine_name for start_cmd in start_cmds]

            # delete machines that are no longer part of the test
            to_del = []
            for idx, machine in enumerate(self.machines):
                py_name = pythonize_name(machine.name)
                if machine.name not in names:
                    if machine.booted:
                        self.logger.warning(
                            f"skipping removal of {machine.name} from the test, because it's running. Call {py_name}.shutdown() and re-run rebuild() to remove."
                        )
                    else:
                        to_del.append(idx)
            for idx in sorted(to_del, reverse=True):
                py_name = pythonize_name(self.machines[idx].name)
                self.logger.info(
                    f"{self.machines[idx].name} removed from the test. deleting it from the environment"
                )
                del repl_globals[py_name]
                del self.machines[idx]

            # add and change new machines
            for start_cmd in start_cmds:
                existing = [
                    m for m in self.machines if m.name == start_cmd.machine_name
                ]
                if len(existing) == 0:
                    machine = self.create_machine(start_cmd._cmd)
                    py_name = pythonize_name(machine.name)
                    repl_globals[py_name] = machine
                    self.machines.append(machine)

                    self.logger.info(
                        f"new machine created {start_cmd.machine_name}. start it with {py_name}.start()"
                    )
                elif len(existing) == 1:
                    machine = existing[0]
                    if machine.start_command._cmd == start_cmd._cmd:
                        self.logger.info(f"{start_cmd.machine_name} unchanged.")
                    elif not machine.booted:
                        self.logger.info(f"{start_cmd.machine_name} changed.")
                        machine.start_command = start_cmd
                    else:
                        with self.logger.nested(
                            f"{start_cmd.machine_name} updated. switching to new configuration"
                        ):
                            store_path = Path(start_cmd._cmd).parent.parent
                            store_path_exists, _ = machine.execute(f"ls {store_path}")
                            if store_path_exists != 0:
                                self.logger.error(
                                    f"Skipping the update of {start_cmd.machine_name}, because the store output {start_cmd._cmd} does not exist on the VM. This will happen if `virtualisation.useNixStoreImage = true;`."
                                )
                            else:
                                switch_cmd = (
                                    store_path
                                    / "system"
                                    / "bin"
                                    / "switch-to-configuration"
                                )
                                machine.succeed(f"{switch_cmd} test")
                                machine.start_command = start_cmd
                else:
                    self.logger.error(
                        f"Skipping the update of {start_cmd.machine_name}, because there are multiple machines with that name. This shouldn't be possible, and is an error in the testing framework."
                    )

        with self.logger.nested("updating vlans"):
            nrs = list(set([int(vlan) for vlan in vlans_str.split(" ")]))
            to_del = []
            for idx, vlan in enumerate(self.vlans):
                if vlan.nr not in nrs:
                    to_del.append(idx)
            for idx in sorted(to_del, reverse=True):
                self.logger.info(
                    f"vlan {self.vlans[idx].nr} removed from test. Deleting it"
                )
                del self.vlans[idx]
            # add new vlans
            old_nrs = [vlan.nr for vlan in self.vlans]
            for nr in nrs:
                if nr not in old_nrs:
                    self.vlans.append(VLan(nr, tmp_dir, self.logger))

        new_tests = Path(testscript).read_text()
        if new_tests != self.tests:
            self.tests = Path(testscript).read_text()
            self.logger.info(
                "Test script updated. We cannot post-hoc modify anything caused by running test_script(), but if you run it now it will reflect the new version."
            )

        # we can't copy the existing outputs over to the new directory because there might be other files mixed in (and usually is)
        new_out_dir = Path(output_directory)
        if new_out_dir != self.out_dir:
            self.logger.info(
                "new output directory: `{new_out_dir}`. Already transferred files will remain in old directory `{self.out_dir}`."
            )
            self.out_dir = new_out_dir

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
            rebuild=self.rebuild,
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
        start_command: str,
        *,
        name: str | None = None,
        keep_vm_state: bool = False,
    ) -> Machine:
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
