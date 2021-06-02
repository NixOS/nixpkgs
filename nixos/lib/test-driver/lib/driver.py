from contextlib import contextmanager
from queue import Queue, Empty
from typing import Tuple, Any, Dict, Iterator
from xml.sax.saxutils import XMLGenerator
from colorama import Style
import atexit
import codecs
import os
import ptpython.repl
import pty
import re
import subprocess
import sys
import tempfile
import time
import traceback
import unicodedata

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
                "log": self.log,
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
            self.log.close()

    @contextmanager
    def subtest(self, name: str) -> Iterator[None]:
        with self.log.nested(name):
            try:
                yield
                return True
            except Exception as e:
                self.log.log(f'Test "{name}" failed with error: "{e}"')
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


class Logger:
    def __init__(self) -> None:
        self.logfile = os.environ.get("LOGFILE", "/dev/null")
        self.logfile_handle = codecs.open(self.logfile, "wb")
        self.xml = XMLGenerator(self.logfile_handle, encoding="utf-8")
        self.queue: "Queue[Dict[str, str]]" = Queue()

        self.xml.startDocument()
        self.xml.startElement("logfile", attrs={})

        self.enable_serial_logs = True  # switchable at runtime

    def close(self) -> None:
        self.xml.endElement("logfile")
        self.xml.endDocument()
        self.logfile_handle.close()

    def sanitise(self, message: str) -> str:
        return "".join(ch for ch in message if unicodedata.category(ch)[0] != "C")

    def maybe_prefix(self, message: str, attributes: Dict[str, str]) -> str:
        if "machine" in attributes:
            return "{}: {}".format(attributes["machine"], message)
        return message

    def log_line(self, message: str, attributes: Dict[str, str]) -> None:
        self.xml.startElement("line", attributes)
        self.xml.characters(message)
        self.xml.endElement("line")

    def log(self, message: str, attributes: Dict[str, str] = {}) -> None:
        common.eprint(self.maybe_prefix(message, attributes))
        self.drain_log_queue()
        self.log_line(message, attributes)

    def log_serial(self, message: str, machine: str) -> None:
        self.enqueue({"msg": message, "machine": machine, "type": "serial"})
        if self._print_serial_logs:
            common.eprint(Style.DIM + "{} # {}".format(machine, message) + Style.RESET_ALL)

    def enqueue(self, item: Dict[str, str]) -> None:
        self.queue.put(item)

    def drain_log_queue(self) -> None:
        try:
            while True:
                item = self.queue.get_nowait()
                msg = self.sanitise(item["msg"])
                del item["msg"]
                self.log_line(msg, item)
        except Empty:
            pass

    @contextmanager
    def nested(self, message: str, attributes: Dict[str, str] = {}) -> Iterator[None]:
        common.eprint(self.maybe_prefix(message, attributes))

        self.xml.startElement("nest", attrs={})
        self.xml.startElement("head", attributes)
        self.xml.characters(message)
        self.xml.endElement("head")

        tic = time.time()
        self.drain_log_queue()
        yield
        self.drain_log_queue()
        toc = time.time()
        self.log("({:.2f} seconds)".format(toc - tic))

        self.xml.endElement("nest")
