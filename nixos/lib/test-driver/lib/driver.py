"""The Driver domain knows how to initialize the test environment,
specifically available symbols machines & vlans, start them up
and run the tests.
"""

from contextlib import contextmanager
from typing import Iterator, List, Dict, Any, Type
import atexit
import os
import tempfile

from pathlib import Path
from pprint import pprint

from vlan import VLan
from startcommand import NixStartScript
from machine import Machine

# for typing
from logger import Logger


class Driver:
    """A handle to the driver that sets up the environment
    and runs the tests"""
    logger: Logger
    vm_scripts: List[str]
    tests: str
    keep_vm_state: bool = False
    machine_class: Type[Machine] = Machine
    vlan_class: Type[VLan] = VLan

    def __init__(
        self,
        logger: Logger,
        vm_scripts: List[str],
        tests: str,
        keep_vm_state: bool = False,
        machine_class: Type[Machine] = Machine,
        vlan_class: Type[VLan] = VLan,
    ):
        """
        Args:
            - configure_python_repl: a function to configure ptpython.repl
        """
        self.log = logger
        self.tests = tests

        tmp_dir = Path(os.environ.get("TMPDIR", tempfile.gettempdir()))
        tmp_dir.mkdir(mode=0o700, exist_ok=True)

        self.vlans = [
            vlan_class(int(nr), tmp_dir, logger.log_machinestate)
            for nr in list(dict.fromkeys(os.environ.get("VLANS", "").split()))
        ]

        def cmd(scripts: List[str]) -> Iterator[NixStartScript]:
            for s in scripts:
                yield NixStartScript(s)

        self.machines = [
            machine_class(
                start_command=cmd,
                keep_vm_state=keep_vm_state,
                name=cmd.machine_name,
                log_serial=logger.log_serial,
                log_machinestate=logger.log_machinestate,
                tmp_dir=tmp_dir,
            )
            for cmd in cmd(vm_scripts)
        ]

        @atexit.register
        def clean_up() -> None:
            with self.log.nested("clean up"):
                for machine in self.machines:
                    machine.release()
                for vlan in self.vlans:
                    vlan.release()
            self.log.release()

    def subtest(self, name: str) -> Iterator[None]:
        """Group logs under a given test name"""
        with self.log.nested(name):
            try:
                yield
                return True
            except:
                self.log(f'Test "{name}" failed with error:')
                raise

    def test_symbols(self) -> Dict[str, Any]:
        @contextmanager
        def subtest(name: str) -> Iterator[None]:
            return self.subtest(name)

        general_symbols = dict(
            pprint=pprint,
            os=os,
            driver=self,
            logger=self.log,
            vlans=self.vlans,
            machines=self.machines,
            start_all=self.start_all,
            test_script=self.test_script,
            subtest=subtest,
        )
        machine_symbols = {
            m.name: self.machines[idx] for idx, m in enumerate(self.machines)
        }
        vlan_symbols = {
            f"vlan{v.nr}": self.vlans[idx] for idx, v in enumerate(self.vlans)
        }
        print(
            "Available Symbols:\n    "
            + ", ".join(map(lambda m: m.name, self.machines))
            + "  -  "
            + ", ".join(map(lambda v: f"vlan{v.nr}", self.vlans))
            + "\n    -------\n    "
            + ", ".join(list(general_symbols.keys()))
        )
        return {**general_symbols, **machine_symbols, **vlan_symbols}

    def test_script(self) -> None:
        """Run the test script"""
        with self.log.nested("run the VM test script"):
            exec(self.tests, self.test_symbols())

    def run_tests(self) -> None:
        """Run the test script (for non-interactive test runs)
        """
        self.test_script()
        # TODO: Collect coverage data
        for machine in self.machines:
            if machine.is_up():
                machine.execute("sync")

    def start_all(self) -> None:
        """Start all machines"""
        with self.log.nested("start all VLans"):
            for vlan in self.vlans:
                vlan.start()
        with self.log.nested("start all VMs"):
            for machine in self.machines:
                machine.start()

    def join_all(self) -> None:
        """Wait for all machines to shut down"""
        with self.log.nested("wait for all VMs to finish"):
            for machine in self.machines:
                machine._wait_for_shutdown()
