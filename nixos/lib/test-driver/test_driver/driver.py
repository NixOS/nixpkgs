from contextlib import contextmanager
from pathlib import Path
from typing import Any, Dict, Iterator, List
import os
import tempfile

from test_driver.logger import rootlog
from test_driver.machine import Machine, NixStartScript, retry
from test_driver.vlan import VLan


class Driver:
    """A handle to the driver that sets up the environment
    and runs the tests"""

    tests: str
    vlans: List[VLan]
    machines: List[Machine]

    def __init__(
        self,
        start_scripts: List[str],
        vlans: List[int],
        tests: str,
        keep_vm_state: bool = False,
    ):
        self.tests = tests

        tmp_dir = Path(os.environ.get("TMPDIR", tempfile.gettempdir()))
        tmp_dir.mkdir(mode=0o700, exist_ok=True)

        with rootlog.nested("start all VLans"):
            self.vlans = [VLan(nr, tmp_dir) for nr in vlans]

        def cmd(scripts: List[str]) -> Iterator[NixStartScript]:
            for s in scripts:
                yield NixStartScript(s)

        self.machines = [
            Machine(
                start_command=cmd,
                keep_vm_state=keep_vm_state,
                name=cmd.machine_name,
                tmp_dir=tmp_dir,
            )
            for cmd in cmd(start_scripts)
        ]

    def __enter__(self) -> "Driver":
        return self

    def __exit__(self, *_: Any) -> None:
        with rootlog.nested("cleanup"):
            for machine in self.machines:
                machine.release()

    def subtest(self, name: str) -> Iterator[None]:
        """Group logs under a given test name"""
        with rootlog.nested(name):
            try:
                yield
                return True
            except Exception as e:
                rootlog.error(f'Test "{name}" failed with error: "{e}"')
                raise e

    def test_symbols(self) -> Dict[str, Any]:
        @contextmanager
        def subtest(name: str) -> Iterator[None]:
            return self.subtest(name)

        general_symbols = dict(
            start_all=self.start_all,
            test_script=self.test_script,
            machines=self.machines,
            vlans=self.vlans,
            driver=self,
            log=rootlog,
            os=os,
            create_machine=self.create_machine,
            subtest=subtest,
            run_tests=self.run_tests,
            join_all=self.join_all,
            retry=retry,
            serial_stdout_off=self.serial_stdout_off,
            serial_stdout_on=self.serial_stdout_on,
            Machine=Machine,  # for typing
        )
        machine_symbols = {m.name: m for m in self.machines}
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
        with rootlog.nested("run the VM test script"):
            symbols = self.test_symbols()  # call eagerly
            exec(self.tests, symbols, None)

    def run_tests(self) -> None:
        """Run the test script (for non-interactive test runs)"""
        self.test_script()
        # TODO: Collect coverage data
        for machine in self.machines:
            if machine.is_up():
                machine.execute("sync")

    def start_all(self) -> None:
        """Start all machines"""
        with rootlog.nested("start all VMs"):
            for machine in self.machines:
                machine.start()

    def join_all(self) -> None:
        """Wait for all machines to shut down"""
        with rootlog.nested("wait for all VMs to finish"):
            for machine in self.machines:
                machine.wait_for_shutdown()

    def create_machine(self, args: Dict[str, Any]) -> Machine:
        rootlog.warning(
            "Using legacy create_machine(), please instantiate the"
            "Machine class directly, instead"
        )
        tmp_dir = Path(os.environ.get("TMPDIR", tempfile.gettempdir()))
        tmp_dir.mkdir(mode=0o700, exist_ok=True)

        if args.get("startCommand"):
            start_command: str = args.get("startCommand", "")
            cmd = NixStartScript(start_command)
            name = args.get("name", cmd.machine_name)
        else:
            cmd = Machine.create_startcommand(args)  # type: ignore
            name = args.get("name", "machine")

        return Machine(
            tmp_dir=tmp_dir,
            start_command=cmd,
            name=name,
            keep_vm_state=args.get("keep_vm_state", False),
            allow_reboot=args.get("allow_reboot", False),
        )

    def serial_stdout_on(self) -> None:
        rootlog._print_serial_logs = True

    def serial_stdout_off(self) -> None:
        rootlog._print_serial_logs = False
