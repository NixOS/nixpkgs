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

from logger import nested
import logging


rootlog = logging.getLogger()


class Driver:
    """A handle to the driver that sets up the environment
    and runs the tests"""

    vm_scripts: List[str]
    tests: str
    keep_vm_state: bool = False
    machine_class: Type[Machine] = Machine
    vlan_class: Type[VLan] = VLan

    def __init__(
        self,
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
        self.tests = tests

        tmp_dir = Path(os.environ.get("TMPDIR", tempfile.gettempdir()))
        tmp_dir.mkdir(mode=0o700, exist_ok=True)

        self.vlans = [
            vlan_class(int(nr), tmp_dir)
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
                tmp_dir=tmp_dir,
            )
            for cmd in cmd(vm_scripts)
        ]

        @atexit.register
        def clean_up() -> None:
            with nested(rootlog, "clean up"):
                for machine in self.machines:
                    machine.release()
                for vlan in self.vlans:
                    vlan.release()

    def subtest(self, name: str) -> Iterator[None]:
        """Group logs under a given test name"""
        with nested(rootlog, name):
            try:
                yield
                return True
            except:
                rootlog.error(f'Test "{name}" failed with error:')
                raise

    def test_symbols(self) -> Dict[str, Any]:
        @contextmanager
        def subtest(name: str) -> Iterator[None]:
            return self.subtest(name)

        general_symbols = dict(
            pprint=pprint,
            os=os,
            driver=self,
            logger=rootlog,
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
        with nested(rootlog, "run the VM test script"):
            exec(self.tests, self.test_symbols())

    def run_tests(self) -> None:
        """Run the test script (for non-interactive test runs)"""
        self.test_script()
        # TODO: Collect coverage data
        for machine in self.machines:
            if machine.is_up():
                machine.execute("sync")

    def start_all(self) -> None:
        """Start all machines"""
        with nested(rootlog, "start all VLans"):
            for vlan in self.vlans:
                vlan.start()
        with nested(rootlog, "start all VMs"):
            for machine in self.machines:
                machine.start()

    def join_all(self) -> None:
        """Wait for all machines to shut down"""
        with nested(rootlog, "wait for all VMs to finish"):
            for machine in self.machines:
                machine._wait_for_shutdown()
