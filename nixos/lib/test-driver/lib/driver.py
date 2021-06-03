from contextlib import contextmanager
from typing import Iterator, Optional
import atexit
import os
import ptpython.repl
import pty
import re
import subprocess
import sys
import tempfile
import traceback

import common


def test_script() -> None:
    exec(os.environ["testScript"])


class Driver():
    def __init__(self, machine_class, log, vm_scripts, keep_vm_state,
                 configure_python_repl=id,
                 machine_config_modifier=lambda x: x):
        """
        Args:
            - configure_python_repl: a function to configure the ptpython.repl
        """
        self.log = log
        self.machine_class = machine_class
        self.vm_scripts = vm_scripts
        self.configure_python_repl = configure_python_repl

        tmp_dir = os.environ.get("TMPDIR", tempfile.gettempdir())
        os.makedirs(tmp_dir, mode=0o700, exist_ok=True)

        vlan_nrs = list(dict.fromkeys(os.environ.get("VLANS", "").split()))
        vde_sockets = [self.create_vlan(v) for v in vlan_nrs]
        for nr, vde_socket, _, _ in vde_sockets:
            os.environ["QEMU_VDE_SOCKET_{}".format(nr)] = vde_socket

        def create_machine(command):
            name = "machine"
            match = re.search("run-(.+)-vm$", command)
            if match:
                name = match.group(1)
            args = {
                "startCommand": command,
                "keepVmState": keep_vm_state,
                "name": name,
                "redirectSerial": os.environ.get("USE_SERIAL", "0") == "1",
                "log_serial": log.log_serial,
                "log_machinestate": log.log_machinestate,
                "tmp_dir": tmp_dir,
            }
            return self.machine_class(machine_config_modifier(args))

        self.machines = [create_machine(s) for s in self.vm_scripts]

        @atexit.register
        def clean_up() -> None:
            with self.log.nested("cleaning up"):
                for machine in machines:
                    machine.release()
                for _, _, process, _ in vde_sockets:
                    process.terminate()
            self.log.release()

    @contextmanager
    def subtest(self, name: str) -> Iterator[None]:
        with self.log.nested(name):
            try:
                yield
                return True
            except Exception as e:
                self.log(f'Test "{name}" failed with error: "{e}"')
                raise e

        return False

    def export_symbols(self):
        global machines
        machines = self.machines
        machine_eval = [
            "global {0}; {0} = machines[{1}]".format(m.name, idx) for idx, m in enumerate(machines)
        ]

        exec("\n".join(machine_eval))

        global start_all, test_script
        start_all = self.start_all

        global subtest

        def subtest(name):
            self.subtest(name)

    def run_tests(self) -> None:
        tests = os.environ.get("tests", None)
        if tests is not None:
            with self.log.nested("running the VM test script"):
                try:
                    exec(tests, globals())
                except Exception:
                    common.eprint("error: ")
                    traceback.print_exc()
                    sys.exit(1)
        else:
            ptpython.repl.embed(
                locals(), globals(),
                configure=self.configure_python_repl)

        # TODO: Collect coverage data

        for machine in self.machines:
            if machine.is_up():
                machine.execute("sync")

    def start_all(self) -> None:
        with self.log.nested("starting all VMs"):
            for machine in self.machines:
                machine.start()

    def join_all(self) -> None:
        with self.log.nested("waiting for all VMs to finish"):
            for machine in self.machines:
                machine.wait_for_shutdown()

    def create_vlan(self, vlan_nr: str) -> Tuple[str, str, "subprocess.Popen[bytes]", Any]:
        self.log.log("starting VDE switch for network {}".format(vlan_nr))
        vde_socket = tempfile.mkdtemp(
            prefix="nixos-test-vde-", suffix="-vde{}.ctl".format(vlan_nr)
        )
        pty_master, pty_slave = pty.openpty()
        vde_process = subprocess.Popen(
            ["vde_switch", "-s", vde_socket, "--dirmode", "0700"],
            stdin=pty_slave,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            shell=False,
        )
        fd = os.fdopen(pty_master, "w")
        fd.write("version\n")
        # TODO: perl version checks if this can be read from
        # an if not, dies. we could hang here forever. Fix it.
        assert vde_process.stdout is not None
        vde_process.stdout.readline()
        if not os.path.exists(os.path.join(vde_socket, "ctl")):
            raise Exception("cannot start vde_switch")

        return (vlan_nr, vde_socket, vde_process, fd)
