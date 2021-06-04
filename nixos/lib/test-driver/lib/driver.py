from contextlib import contextmanager
from typing import Iterator, Optional, Callable
import atexit
import os
import ptpython.repl
import pty
import subprocess
import tempfile

from pathlib import Path
from pprint import pprint

from machine import Machine, NixStartScript


class VLan ():
    def __init__(self, nr: int, tmp_dir: Path, log: Callable):
        self.nr = nr
        self.socket_dir = tmp_dir / f"vde{self.nr}.ctl"
        self.log = lambda msg: log(
            f"[VLAN NR {self.nr}] {msg}", {"vde": self.nr})

        self.process: Optional[subprocess.Popen] = None
        self.pid: Optional[int] = None
        self.fd: Optional[os.file] = None

        # TODO: don't side-effect environment here
        os.environ[f"QEMU_VDE_SOCKET_{self.nr}"] = str(self.socket_dir)

    def start(self):

        self.log("start")
        pty_master, pty_slave = pty.openpty()

        self.process = subprocess.Popen(
            ["vde_switch", "-s", self.socket_dir, "--dirmode", "0700"],
            stdin=pty_slave,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            shell=False,
        )
        self.pid = self.process.pid
        self.fd = os.fdopen(pty_master, "w")
        self.fd.write("version\n")

        # TODO: perl version checks if this can be read from
        # an if not, dies. we could hang here forever. Fix it.
        assert self.process.stdout is not None
        self.process.stdout.readline()
        if not (self.socket_dir / "ctl").exists():
            raise Exception("cannot start vde_switch")

        self.log(f"running (pid {self.pid})")

    def release(self):
        if self.pid is None:
            return
        self.log(f"kill me (pid {self.pid})")
        if self.fd is not None:
            self.fd.close()
        if self.process is not None:
            self.process.terminate()


class Driver():
    def __init__(
        self,
        logger,
        vm_scripts,
        keep_vm_state=False,
        configure_python_repl=id,
        machine_class=Machine,
        vlan_class=VLan,
    ):
        """
        Args:
            - configure_python_repl: a function to configure ptpython.repl
        """
        self.log = logger
        self.configure_python_repl = configure_python_repl

        tmp_dir = Path(os.environ.get("TMPDIR", tempfile.gettempdir()))
        tmp_dir.mkdir(mode=0o700, exist_ok=True)

        self.vlans = [
            vlan_class(nr, tmp_dir, logger.log_machinestate) for nr in
            list(dict.fromkeys(os.environ.get("VLANS", "").split()))
        ]

        def cmd(scripts):
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
            ) for cmd in cmd(vm_scripts)
        ]

        @atexit.register
        def clean_up() -> None:
            with self.log.nested("clean up"):
                for machine in self.machines:
                    machine.release()
                for vlan in self.vlans:
                    vlan.release()
            self.log.release()

    @contextmanager
    def subtest(self, name: str) -> Iterator[None]:
        """Group logs under a given test name
        """
        with self.log.nested(name):
            try:
                yield
                return True
            except:
                self.log(f'Test "{name}" failed with error:')
                raise

    def test_symbols(self):

        def subtest(name):
            self.subtest(name)

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
        """Run the test script from the environment ('testScript')
        """
        with self.log.nested("run the VM test script"):
            exec(os.environ["testScript"])

    def run_tests(self) -> None:
        """Run all tests from the environment ('test')
        or drop into a python repl for interactive execution
        """
        tests = os.environ.get("tests")
        if tests is not None:
            with self.log.nested("run the VM test script"):
                exec(tests, self.test_symbols())
        else:
            ptpython.repl.embed(
                self.test_symbols(), {},
                configure=self.configure_python_repl)

        # TODO: Collect coverage data

        for machine in self.machines:
            if machine.is_up():
                machine.execute("sync")

    def start_all(self) -> None:
        """Start all machines
        """
        with self.log.nested("start all VLans"):
            for vlan in self.vlans:
                vlan.start()
        with self.log.nested("start all VMs"):
            for machine in self.machines:
                machine.start()

    def join_all(self) -> None:
        """Wait for all machines to shut down
        """
        with self.log.nested("wait for all VMs to finish"):
            for machine in self.machines:
                machine.wait_for_shutdown()
