from contextlib import contextmanager
from typing import Iterator, Optional
import atexit
import os
import ptpython.repl
import pty
import subprocess
import sys
import tempfile
import traceback

import common

from machine import Machine, NixStartScript


class VLan ():
    def __init__(self, nr: int, tmp_dir: str):
        self.nr = nr
        self.socket_dir = os.path.join(tmp_dir, f"vde{self.nr}.ctl")

        self.process: Optional[subprocess.Popen] = None
        self.pid: Optional[int] = None
        self.fd: Optional[os.file] = None

        # TODO: don't side-effect environment here
        os.environ[f"QEMU_VDE_SOCKET_{self.nr}"] = self.socket_dir

    def start(self):
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
        if not os.path.exists(os.path.join(self.socket_dir, "ctl")):
            raise Exception("cannot start vde_switch")

    def release(self):
        self.fd.close()
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

        tmp_dir = os.environ.get("TMPDIR", tempfile.gettempdir())
        os.makedirs(tmp_dir, mode=0o700, exist_ok=True)

        self.vlans = [
            self.log(f"starting VDE switch for network {nr}") and
            vlan_class(nr, tmp_dir) for nr in
            list(dict.fromkeys(os.environ.get("VLANS", "").split()))
        ]

        def cmd(scripts):
            for s in scripts:
                yield NixStartScript(s)

        self.machines = [
            self.log(f"creating VM '{cmd.machine_name}'") and
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
            with self.log.nested("cleaning up"):
                for machine in self.machines:
                    if not machine.release():
                        continue
                    self.log(f"killed {machine.name} (pid {machine.pid})")
                for vlan in self.vlans:
                    vlan.release()
                    self.log(f"killed {vlan.nr} (pid {vlan.pid})")
            self.log.release()

    @contextmanager
    def subtest(self, name: str) -> Iterator[None]:
        with self.log.nested(name):
            try:
                yield
                return True
            except:
                self.log(f'Test "{name}" failed with error:')
                raise

    def export_symbols(self):
        global machines
        machines = self.machines
        machine_eval = [
            "global {0}; {0} = machines[{1}]".format(m.name, idx) for idx, m in enumerate(machines)
        ]

        exec("\n".join(machine_eval))

        global start_all, test_script
        start_all = self.start_all
        test_script = self.test_script

        global subtest

        def subtest(name):
            self.subtest(name)

    def test_script(self) -> None:
        with self.log.nested("running the VM test script"):
            exec(os.environ["testScript"])

    def run_tests(self) -> None:
        tests = os.environ.get("tests")
        if tests is not None:
            with self.log.nested("running the VM test script"):
                exec(tests, globals())
        else:
            ptpython.repl.embed(
                locals(), globals(),
                configure=self.configure_python_repl)

        # TODO: Collect coverage data

        for machine in self.machines:
            if machine.is_up():
                machine.execute("sync")

    def start_all(self) -> None:
        with self.log.nested("starting all VLans"):
            for vlan in self.vlans:
                vlan.start()
        with self.log.nested("starting all VMs"):
            for machine in self.machines:
                machine.start()

    def join_all(self) -> None:
        with self.log.nested("waiting for all VMs to finish"):
            for machine in self.machines:
                machine.wait_for_shutdown()
