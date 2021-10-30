#! /somewhere/python3
from contextlib import contextmanager, _GeneratorContextManager
from queue import Queue, Empty
from typing import Tuple, Any, Callable, Dict, Iterator, Optional, List, Iterable
from xml.sax.saxutils import XMLGenerator
from colorama import Style
import queue
import io
import threading
import argparse
import base64
import codecs
import os
import pathlib
import ptpython.repl
import pty
import re
import shlex
import shutil
import socket
import subprocess
import sys
import tempfile
import time
import unicodedata

CHAR_TO_KEY = {
    "A": "shift-a",
    "N": "shift-n",
    "-": "0x0C",
    "_": "shift-0x0C",
    "B": "shift-b",
    "O": "shift-o",
    "=": "0x0D",
    "+": "shift-0x0D",
    "C": "shift-c",
    "P": "shift-p",
    "[": "0x1A",
    "{": "shift-0x1A",
    "D": "shift-d",
    "Q": "shift-q",
    "]": "0x1B",
    "}": "shift-0x1B",
    "E": "shift-e",
    "R": "shift-r",
    ";": "0x27",
    ":": "shift-0x27",
    "F": "shift-f",
    "S": "shift-s",
    "'": "0x28",
    '"': "shift-0x28",
    "G": "shift-g",
    "T": "shift-t",
    "`": "0x29",
    "~": "shift-0x29",
    "H": "shift-h",
    "U": "shift-u",
    "\\": "0x2B",
    "|": "shift-0x2B",
    "I": "shift-i",
    "V": "shift-v",
    ",": "0x33",
    "<": "shift-0x33",
    "J": "shift-j",
    "W": "shift-w",
    ".": "0x34",
    ">": "shift-0x34",
    "K": "shift-k",
    "X": "shift-x",
    "/": "0x35",
    "?": "shift-0x35",
    "L": "shift-l",
    "Y": "shift-y",
    " ": "spc",
    "M": "shift-m",
    "Z": "shift-z",
    "\n": "ret",
    "!": "shift-0x02",
    "@": "shift-0x03",
    "#": "shift-0x04",
    "$": "shift-0x05",
    "%": "shift-0x06",
    "^": "shift-0x07",
    "&": "shift-0x08",
    "*": "shift-0x09",
    "(": "shift-0x0A",
    ")": "shift-0x0B",
}


class Logger:
    def __init__(self) -> None:
        self.logfile = os.environ.get("LOGFILE", "/dev/null")
        self.logfile_handle = codecs.open(self.logfile, "wb")
        self.xml = XMLGenerator(self.logfile_handle, encoding="utf-8")
        self.queue: "Queue[Dict[str, str]]" = Queue()

        self.xml.startDocument()
        self.xml.startElement("logfile", attrs={})

        self._print_serial_logs = True

    @staticmethod
    def _eprint(*args: object, **kwargs: Any) -> None:
        print(*args, file=sys.stderr, **kwargs)

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

    def info(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def warning(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)

    def error(self, *args, **kwargs) -> None:  # type: ignore
        self.log(*args, **kwargs)
        sys.exit(1)

    def log(self, message: str, attributes: Dict[str, str] = {}) -> None:
        self._eprint(self.maybe_prefix(message, attributes))
        self.drain_log_queue()
        self.log_line(message, attributes)

    def log_serial(self, message: str, machine: str) -> None:
        self.enqueue({"msg": message, "machine": machine, "type": "serial"})
        if self._print_serial_logs:
            self._eprint(
                Style.DIM + "{} # {}".format(machine, message) + Style.RESET_ALL
            )

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
        self._eprint(self.maybe_prefix(message, attributes))

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


rootlog = Logger()


def make_command(args: list) -> str:
    return " ".join(map(shlex.quote, (map(str, args))))


def retry(fn: Callable, timeout: int = 900) -> None:
    """Call the given function repeatedly, with 1 second intervals,
    until it returns True or a timeout is reached.
    """

    for _ in range(timeout):
        if fn(False):
            return
        time.sleep(1)

    if not fn(True):
        raise Exception(f"action timed out after {timeout} seconds")


def _perform_ocr_on_screenshot(
    screenshot_path: str, model_ids: Iterable[int]
) -> List[str]:
    if shutil.which("tesseract") is None:
        raise Exception("OCR requested but enableOCR is false")

    magick_args = (
        "-filter Catrom -density 72 -resample 300 "
        + "-contrast -normalize -despeckle -type grayscale "
        + "-sharpen 1 -posterize 3 -negate -gamma 100 "
        + "-blur 1x65535"
    )

    tess_args = f"-c debug_file=/dev/null --psm 11"

    cmd = f"convert {magick_args} {screenshot_path} tiff:{screenshot_path}.tiff"
    ret = subprocess.run(cmd, shell=True, capture_output=True)
    if ret.returncode != 0:
        raise Exception(f"TIFF conversion failed with exit code {ret.returncode}")

    model_results = []
    for model_id in model_ids:
        cmd = f"tesseract {screenshot_path}.tiff - {tess_args} --oem {model_id}"
        ret = subprocess.run(cmd, shell=True, capture_output=True)
        if ret.returncode != 0:
            raise Exception(f"OCR failed with exit code {ret.returncode}")
        model_results.append(ret.stdout.decode("utf-8"))

    return model_results


class StartCommand:
    """The Base Start Command knows how to append the necesary
    runtime qemu options as determined by a particular test driver
    run. Any such start command is expected to happily receive and
    append additional qemu args.
    """

    _cmd: str

    def cmd(
        self,
        monitor_socket_path: pathlib.Path,
        shell_socket_path: pathlib.Path,
        allow_reboot: bool = False,  # TODO: unused, legacy?
    ) -> str:
        display_opts = ""
        display_available = any(x in os.environ for x in ["DISPLAY", "WAYLAND_DISPLAY"])
        if not display_available:
            display_opts += " -nographic"

        # qemu options
        qemu_opts = ""
        qemu_opts += (
            ""
            if allow_reboot
            else " -no-reboot"
            " -device virtio-serial"
            " -device virtconsole,chardev=shell"
            " -device virtio-rng-pci"
            " -serial stdio"
        )
        # TODO: qemu script already catpures this env variable, legacy?
        qemu_opts += " " + os.environ.get("QEMU_OPTS", "")

        return (
            f"{self._cmd}"
            f" -monitor unix:{monitor_socket_path}"
            f" -chardev socket,id=shell,path={shell_socket_path}"
            f"{qemu_opts}"
            f"{display_opts}"
        )

    @staticmethod
    def build_environment(
        state_dir: pathlib.Path,
        shared_dir: pathlib.Path,
    ) -> dict:
        # We make a copy to not update the current environment
        env = dict(os.environ)
        env.update(
            {
                "TMPDIR": str(state_dir),
                "SHARED_DIR": str(shared_dir),
                "USE_TMPDIR": "1",
            }
        )
        return env

    def run(
        self,
        state_dir: pathlib.Path,
        shared_dir: pathlib.Path,
        monitor_socket_path: pathlib.Path,
        shell_socket_path: pathlib.Path,
    ) -> subprocess.Popen:
        return subprocess.Popen(
            self.cmd(monitor_socket_path, shell_socket_path),
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            shell=True,
            cwd=state_dir,
            env=self.build_environment(state_dir, shared_dir),
        )


class NixStartScript(StartCommand):
    """A start script from nixos/modules/virtualiation/qemu-vm.nix
    that also satisfies the requirement of the BaseStartCommand.
    These Nix commands have the particular charactersitic that the
    machine name can be extracted out of them via a regex match.
    (Admittedly a _very_ implicit contract, evtl. TODO fix)
    """

    def __init__(self, script: str):
        self._cmd = script

    @property
    def machine_name(self) -> str:
        match = re.search("run-(.+)-vm$", self._cmd)
        name = "machine"
        if match:
            name = match.group(1)
        return name


class LegacyStartCommand(StartCommand):
    """Used in some places to create an ad-hoc machine instead of
    using nix test instrumentation + module system for that purpose.
    Legacy.
    """

    def __init__(
        self,
        netBackendArgs: Optional[str] = None,
        netFrontendArgs: Optional[str] = None,
        hda: Optional[Tuple[pathlib.Path, str]] = None,
        cdrom: Optional[str] = None,
        usb: Optional[str] = None,
        bios: Optional[str] = None,
        qemuFlags: Optional[str] = None,
    ):
        self._cmd = "qemu-kvm -m 384"

        # networking
        net_backend = "-netdev user,id=net0"
        net_frontend = "-device virtio-net-pci,netdev=net0"
        if netBackendArgs is not None:
            net_backend += "," + netBackendArgs
        if netFrontendArgs is not None:
            net_frontend += "," + netFrontendArgs
        self._cmd += f" {net_backend} {net_frontend}"

        # hda
        hda_cmd = ""
        if hda is not None:
            hda_path = hda[0].resolve()
            hda_interface = hda[1]
            if hda_interface == "scsi":
                hda_cmd += (
                    f" -drive id=hda,file={hda_path},werror=report,if=none"
                    " -device scsi-hd,drive=hda"
                )
            else:
                hda_cmd += f" -drive file={hda_path},if={hda_interface},werror=report"
        self._cmd += hda_cmd

        # cdrom
        if cdrom is not None:
            self._cmd += f" -cdrom {cdrom}"

        # usb
        usb_cmd = ""
        if usb is not None:
            # https://github.com/qemu/qemu/blob/master/docs/usb2.txt
            usb_cmd += (
                " -device usb-ehci"
                f" -drive id=usbdisk,file={usb},if=none,readonly"
                " -device usb-storage,drive=usbdisk "
            )
        self._cmd += usb_cmd

        # bios
        if bios is not None:
            self._cmd += f" -bios {bios}"

        # qemu flags
        if qemuFlags is not None:
            self._cmd += f" {qemuFlags}"


class Machine:
    """A handle to the machine with this name, that also knows how to manage
    the machine lifecycle with the help of a start script / command."""

    name: str
    tmp_dir: pathlib.Path
    shared_dir: pathlib.Path
    state_dir: pathlib.Path
    monitor_path: pathlib.Path
    shell_path: pathlib.Path

    start_command: StartCommand
    keep_vm_state: bool
    allow_reboot: bool

    process: Optional[subprocess.Popen]
    pid: Optional[int]
    monitor: Optional[socket.socket]
    shell: Optional[socket.socket]
    serial_thread: Optional[threading.Thread]

    booted: bool
    connected: bool
    # Store last serial console lines for use
    # of wait_for_console_text
    last_lines: Queue = Queue()

    def __repr__(self) -> str:
        return f"<Machine '{self.name}'>"

    def __init__(
        self,
        tmp_dir: pathlib.Path,
        start_command: StartCommand,
        name: str = "machine",
        keep_vm_state: bool = False,
        allow_reboot: bool = False,
    ) -> None:
        self.tmp_dir = tmp_dir
        self.keep_vm_state = keep_vm_state
        self.allow_reboot = allow_reboot
        self.name = name
        self.start_command = start_command

        # set up directories
        self.shared_dir = self.tmp_dir / "shared-xchg"
        self.shared_dir.mkdir(mode=0o700, exist_ok=True)

        self.state_dir = self.tmp_dir / f"vm-state-{self.name}"
        self.monitor_path = self.state_dir / "monitor"
        self.shell_path = self.state_dir / "shell"
        if (not self.keep_vm_state) and self.state_dir.exists():
            self.cleanup_statedir()
        self.state_dir.mkdir(mode=0o700, exist_ok=True)

        self.process = None
        self.pid = None
        self.monitor = None
        self.shell = None
        self.serial_thread = None

        self.booted = False
        self.connected = False

    @staticmethod
    def create_startcommand(args: Dict[str, str]) -> StartCommand:
        rootlog.warning(
            "Using legacy create_startcommand(),"
            "please use proper nix test vm instrumentation, instead"
            "to generate the appropriate nixos test vm qemu startup script"
        )
        hda = None
        if args.get("hda"):
            hda_arg: str = args.get("hda", "")
            hda_arg_path: pathlib.Path = pathlib.Path(hda_arg)
            hda = (hda_arg_path, args.get("hdaInterface", ""))
        return LegacyStartCommand(
            netBackendArgs=args.get("netBackendArgs"),
            netFrontendArgs=args.get("netFrontendArgs"),
            hda=hda,
            cdrom=args.get("cdrom"),
            usb=args.get("usb"),
            bios=args.get("bios"),
            qemuFlags=args.get("qemuFlags"),
        )

    def is_up(self) -> bool:
        return self.booted and self.connected

    def log(self, msg: str) -> None:
        rootlog.log(msg, {"machine": self.name})

    def log_serial(self, msg: str) -> None:
        rootlog.log_serial(msg, self.name)

    def nested(self, msg: str, attrs: Dict[str, str] = {}) -> _GeneratorContextManager:
        my_attrs = {"machine": self.name}
        my_attrs.update(attrs)
        return rootlog.nested(msg, my_attrs)

    def wait_for_monitor_prompt(self) -> str:
        assert self.monitor is not None
        answer = ""
        while True:
            undecoded_answer = self.monitor.recv(1024)
            if not undecoded_answer:
                break
            answer += undecoded_answer.decode()
            if answer.endswith("(qemu) "):
                break
        return answer

    def send_monitor_command(self, command: str) -> str:
        message = ("{}\n".format(command)).encode()
        self.log("sending monitor command: {}".format(command))
        assert self.monitor is not None
        self.monitor.send(message)
        return self.wait_for_monitor_prompt()

    def wait_for_unit(self, unit: str, user: Optional[str] = None) -> None:
        """Wait for a systemd unit to get into "active" state.
        Throws exceptions on "failed" and "inactive" states as well as
        after timing out.
        """

        def check_active(_: Any) -> bool:
            info = self.get_unit_info(unit, user)
            state = info["ActiveState"]
            if state == "failed":
                raise Exception('unit "{}" reached state "{}"'.format(unit, state))

            if state == "inactive":
                status, jobs = self.systemctl("list-jobs --full 2>&1", user)
                if "No jobs" in jobs:
                    info = self.get_unit_info(unit, user)
                    if info["ActiveState"] == state:
                        raise Exception(
                            (
                                'unit "{}" is inactive and there ' "are no pending jobs"
                            ).format(unit)
                        )

            return state == "active"

        retry(check_active)

    def get_unit_info(self, unit: str, user: Optional[str] = None) -> Dict[str, str]:
        status, lines = self.systemctl('--no-pager show "{}"'.format(unit), user)
        if status != 0:
            raise Exception(
                'retrieving systemctl info for unit "{}" {} failed with exit code {}'.format(
                    unit, "" if user is None else 'under user "{}"'.format(user), status
                )
            )

        line_pattern = re.compile(r"^([^=]+)=(.*)$")

        def tuple_from_line(line: str) -> Tuple[str, str]:
            match = line_pattern.match(line)
            assert match is not None
            return match[1], match[2]

        return dict(
            tuple_from_line(line)
            for line in lines.split("\n")
            if line_pattern.match(line)
        )

    def systemctl(self, q: str, user: Optional[str] = None) -> Tuple[int, str]:
        if user is not None:
            q = q.replace("'", "\\'")
            return self.execute(
                (
                    "su -l {} --shell /bin/sh -c "
                    "$'XDG_RUNTIME_DIR=/run/user/`id -u` "
                    "systemctl --user {}'"
                ).format(user, q)
            )
        return self.execute("systemctl {}".format(q))

    def require_unit_state(self, unit: str, require_state: str = "active") -> None:
        with self.nested(
            "checking if unit ‘{}’ has reached state '{}'".format(unit, require_state)
        ):
            info = self.get_unit_info(unit)
            state = info["ActiveState"]
            if state != require_state:
                raise Exception(
                    "Expected unit ‘{}’ to to be in state ".format(unit)
                    + "'{}' but it is in state ‘{}’".format(require_state, state)
                )

    def execute(self, command: str) -> Tuple[int, str]:
        self.connect()

        out_command = "( set -euo pipefail; {} ); echo '|!=EOF' $?\n".format(command)
        assert self.shell
        self.shell.send(out_command.encode())

        output = ""
        status_code_pattern = re.compile(r"(.*)\|\!=EOF\s+(\d+)")

        while True:
            chunk = self.shell.recv(4096).decode(errors="ignore")
            match = status_code_pattern.match(chunk)
            if match:
                output += match[1]
                status_code = int(match[2])
                return (status_code, output)
            output += chunk

    def shell_interact(self) -> None:
        """Allows you to interact with the guest shell

        Should only be used during test development, not in the production test."""
        self.connect()
        self.log("Terminal is ready (there is no prompt):")

        assert self.shell
        subprocess.run(
            ["socat", "READLINE", f"FD:{self.shell.fileno()}"],
            pass_fds=[self.shell.fileno()],
        )

    def succeed(self, *commands: str) -> str:
        """Execute each command and check that it succeeds."""
        output = ""
        for command in commands:
            with self.nested("must succeed: {}".format(command)):
                (status, out) = self.execute(command)
                if status != 0:
                    self.log("output: {}".format(out))
                    raise Exception(
                        "command `{}` failed (exit code {})".format(command, status)
                    )
                output += out
        return output

    def fail(self, *commands: str) -> str:
        """Execute each command and check that it fails."""
        output = ""
        for command in commands:
            with self.nested("must fail: {}".format(command)):
                (status, out) = self.execute(command)
                if status == 0:
                    raise Exception(
                        "command `{}` unexpectedly succeeded".format(command)
                    )
                output += out
        return output

    def wait_until_succeeds(self, command: str, timeout: int = 900) -> str:
        """Wait until a command returns success and return its output.
        Throws an exception on timeout.
        """
        output = ""

        def check_success(_: Any) -> bool:
            nonlocal output
            status, output = self.execute(command)
            return status == 0

        with self.nested("waiting for success: {}".format(command)):
            retry(check_success, timeout)
            return output

    def wait_until_fails(self, command: str) -> str:
        """Wait until a command returns failure.
        Throws an exception on timeout.
        """
        output = ""

        def check_failure(_: Any) -> bool:
            nonlocal output
            status, output = self.execute(command)
            return status != 0

        with self.nested("waiting for failure: {}".format(command)):
            retry(check_failure)
            return output

    def wait_for_shutdown(self) -> None:
        if not self.booted:
            return

        with self.nested("waiting for the VM to power off"):
            sys.stdout.flush()
            assert self.process
            self.process.wait()

            self.pid = None
            self.booted = False
            self.connected = False

    def get_tty_text(self, tty: str) -> str:
        status, output = self.execute(
            "fold -w$(stty -F /dev/tty{0} size | "
            "awk '{{print $2}}') /dev/vcs{0}".format(tty)
        )
        return output

    def wait_until_tty_matches(self, tty: str, regexp: str) -> None:
        """Wait until the visible output on the chosen TTY matches regular
        expression. Throws an exception on timeout.
        """
        matcher = re.compile(regexp)

        def tty_matches(last: bool) -> bool:
            text = self.get_tty_text(tty)
            if last:
                self.log(
                    f"Last chance to match /{regexp}/ on TTY{tty}, "
                    f"which currently contains: {text}"
                )
            return len(matcher.findall(text)) > 0

        with self.nested("waiting for {} to appear on tty {}".format(regexp, tty)):
            retry(tty_matches)

    def send_chars(self, chars: List[str]) -> None:
        with self.nested("sending keys ‘{}‘".format(chars)):
            for char in chars:
                self.send_key(char)

    def wait_for_file(self, filename: str) -> None:
        """Waits until the file exists in machine's file system."""

        def check_file(_: Any) -> bool:
            status, _ = self.execute("test -e {}".format(filename))
            return status == 0

        with self.nested("waiting for file ‘{}‘".format(filename)):
            retry(check_file)

    def wait_for_open_port(self, port: int) -> None:
        def port_is_open(_: Any) -> bool:
            status, _ = self.execute("nc -z localhost {}".format(port))
            return status == 0

        with self.nested("waiting for TCP port {}".format(port)):
            retry(port_is_open)

    def wait_for_closed_port(self, port: int) -> None:
        def port_is_closed(_: Any) -> bool:
            status, _ = self.execute("nc -z localhost {}".format(port))
            return status != 0

        retry(port_is_closed)

    def start_job(self, jobname: str, user: Optional[str] = None) -> Tuple[int, str]:
        return self.systemctl("start {}".format(jobname), user)

    def stop_job(self, jobname: str, user: Optional[str] = None) -> Tuple[int, str]:
        return self.systemctl("stop {}".format(jobname), user)

    def wait_for_job(self, jobname: str) -> None:
        self.wait_for_unit(jobname)

    def connect(self) -> None:
        if self.connected:
            return

        with self.nested("waiting for the VM to finish booting"):
            self.start()

            assert self.shell

            tic = time.time()
            self.shell.recv(1024)
            # TODO: Timeout
            toc = time.time()

            self.log("connected to guest root shell")
            self.log("(connecting took {:.2f} seconds)".format(toc - tic))
            self.connected = True

    def screenshot(self, filename: str) -> None:
        out_dir = os.environ.get("out", os.getcwd())
        word_pattern = re.compile(r"^\w+$")
        if word_pattern.match(filename):
            filename = os.path.join(out_dir, "{}.png".format(filename))
        tmp = "{}.ppm".format(filename)

        with self.nested(
            "making screenshot {}".format(filename),
            {"image": os.path.basename(filename)},
        ):
            self.send_monitor_command("screendump {}".format(tmp))
            ret = subprocess.run("pnmtopng {} > {}".format(tmp, filename), shell=True)
            os.unlink(tmp)
            if ret.returncode != 0:
                raise Exception("Cannot convert screenshot")

    def copy_from_host_via_shell(self, source: str, target: str) -> None:
        """Copy a file from the host into the guest by piping it over the
        shell into the destination file. Works without host-guest shared folder.
        Prefer copy_from_host for whenever possible.
        """
        with open(source, "rb") as fh:
            content_b64 = base64.b64encode(fh.read()).decode()
            self.succeed(
                f"mkdir -p $(dirname {target})",
                f"echo -n {content_b64} | base64 -d > {target}",
            )

    def copy_from_host(self, source: str, target: str) -> None:
        """Copy a file from the host into the guest via the `shared_dir` shared
        among all the VMs (using a temporary directory).
        """
        host_src = pathlib.Path(source)
        vm_target = pathlib.Path(target)
        with tempfile.TemporaryDirectory(dir=self.shared_dir) as shared_td:
            shared_temp = pathlib.Path(shared_td)
            host_intermediate = shared_temp / host_src.name
            vm_shared_temp = pathlib.Path("/tmp/shared") / shared_temp.name
            vm_intermediate = vm_shared_temp / host_src.name

            self.succeed(make_command(["mkdir", "-p", vm_shared_temp]))
            if host_src.is_dir():
                shutil.copytree(host_src, host_intermediate)
            else:
                shutil.copy(host_src, host_intermediate)
            self.succeed(make_command(["mkdir", "-p", vm_target.parent]))
            self.succeed(make_command(["cp", "-r", vm_intermediate, vm_target]))

    def copy_from_vm(self, source: str, target_dir: str = "") -> None:
        """Copy a file from the VM (specified by an in-VM source path) to a path
        relative to `$out`. The file is copied via the `shared_dir` shared among
        all the VMs (using a temporary directory).
        """
        # Compute the source, target, and intermediate shared file names
        out_dir = pathlib.Path(os.environ.get("out", os.getcwd()))
        vm_src = pathlib.Path(source)
        with tempfile.TemporaryDirectory(dir=self.shared_dir) as shared_td:
            shared_temp = pathlib.Path(shared_td)
            vm_shared_temp = pathlib.Path("/tmp/shared") / shared_temp.name
            vm_intermediate = vm_shared_temp / vm_src.name
            intermediate = shared_temp / vm_src.name
            # Copy the file to the shared directory inside VM
            self.succeed(make_command(["mkdir", "-p", vm_shared_temp]))
            self.succeed(make_command(["cp", "-r", vm_src, vm_intermediate]))
            abs_target = out_dir / target_dir / vm_src.name
            abs_target.parent.mkdir(exist_ok=True, parents=True)
            # Copy the file from the shared directory outside VM
            if intermediate.is_dir():
                shutil.copytree(intermediate, abs_target)
            else:
                shutil.copy(intermediate, abs_target)

    def dump_tty_contents(self, tty: str) -> None:
        """Debugging: Dump the contents of the TTY<n>"""
        self.execute("fold -w 80 /dev/vcs{} | systemd-cat".format(tty))

    def _get_screen_text_variants(self, model_ids: Iterable[int]) -> List[str]:
        with tempfile.TemporaryDirectory() as tmpdir:
            screenshot_path = os.path.join(tmpdir, "ppm")
            self.send_monitor_command(f"screendump {screenshot_path}")
            return _perform_ocr_on_screenshot(screenshot_path, model_ids)

    def get_screen_text_variants(self) -> List[str]:
        return self._get_screen_text_variants([0, 1, 2])

    def get_screen_text(self) -> str:
        return self._get_screen_text_variants([2])[0]

    def wait_for_text(self, regex: str) -> None:
        def screen_matches(last: bool) -> bool:
            variants = self.get_screen_text_variants()
            for text in variants:
                if re.search(regex, text) is not None:
                    return True

            if last:
                self.log("Last OCR attempt failed. Text was: {}".format(variants))

            return False

        with self.nested("waiting for {} to appear on screen".format(regex)):
            retry(screen_matches)

    def wait_for_console_text(self, regex: str) -> None:
        self.log("waiting for {} to appear on console".format(regex))
        # Buffer the console output, this is needed
        # to match multiline regexes.
        console = io.StringIO()
        while True:
            try:
                console.write(self.last_lines.get())
            except queue.Empty:
                self.sleep(1)
                continue
            console.seek(0)
            matches = re.search(regex, console.read())
            if matches is not None:
                return

    def send_key(self, key: str) -> None:
        key = CHAR_TO_KEY.get(key, key)
        self.send_monitor_command("sendkey {}".format(key))

    def start(self) -> None:
        if self.booted:
            return

        self.log("starting vm")

        def clear(path: pathlib.Path) -> pathlib.Path:
            if path.exists():
                path.unlink()
            return path

        def create_socket(path: pathlib.Path) -> socket.socket:
            s = socket.socket(family=socket.AF_UNIX, type=socket.SOCK_STREAM)
            s.bind(str(path))
            s.listen(1)
            return s

        monitor_socket = create_socket(clear(self.monitor_path))
        shell_socket = create_socket(clear(self.shell_path))
        self.process = self.start_command.run(
            self.state_dir,
            self.shared_dir,
            self.monitor_path,
            self.shell_path,
        )
        self.monitor, _ = monitor_socket.accept()
        self.shell, _ = shell_socket.accept()

        # Store last serial console lines for use
        # of wait_for_console_text
        self.last_lines: Queue = Queue()

        def process_serial_output() -> None:
            assert self.process
            assert self.process.stdout
            for _line in self.process.stdout:
                # Ignore undecodable bytes that may occur in boot menus
                line = _line.decode(errors="ignore").replace("\r", "").rstrip()
                self.last_lines.put(line)
                self.log_serial(line)

        self.serial_thread = threading.Thread(target=process_serial_output)
        self.serial_thread.start()

        self.wait_for_monitor_prompt()

        self.pid = self.process.pid
        self.booted = True

        self.log("QEMU running (pid {})".format(self.pid))

    def cleanup_statedir(self) -> None:
        shutil.rmtree(self.state_dir)
        rootlog.log(f"deleting VM state directory {self.state_dir}")
        rootlog.log("if you want to keep the VM state, pass --keep-vm-state")

    def shutdown(self) -> None:
        if not self.booted:
            return

        assert self.shell
        self.shell.send("poweroff\n".encode())
        self.wait_for_shutdown()

    def crash(self) -> None:
        if not self.booted:
            return

        self.log("forced crash")
        self.send_monitor_command("quit")
        self.wait_for_shutdown()

    def wait_for_x(self) -> None:
        """Wait until it is possible to connect to the X server.  Note that
        testing the existence of /tmp/.X11-unix/X0 is insufficient.
        """

        def check_x(_: Any) -> bool:
            cmd = (
                "journalctl -b SYSLOG_IDENTIFIER=systemd | "
                + 'grep "Reached target Current graphical"'
            )
            status, _ = self.execute(cmd)
            if status != 0:
                return False
            status, _ = self.execute("[ -e /tmp/.X11-unix/X0 ]")
            return status == 0

        with self.nested("waiting for the X11 server"):
            retry(check_x)

    def get_window_names(self) -> List[str]:
        return self.succeed(
            r"xwininfo -root -tree | sed 's/.*0x[0-9a-f]* \"\([^\"]*\)\".*/\1/; t; d'"
        ).splitlines()

    def wait_for_window(self, regexp: str) -> None:
        pattern = re.compile(regexp)

        def window_is_visible(last_try: bool) -> bool:
            names = self.get_window_names()
            if last_try:
                self.log(
                    "Last chance to match {} on the window list,".format(regexp)
                    + " which currently contains: "
                    + ", ".join(names)
                )
            return any(pattern.search(name) for name in names)

        with self.nested("Waiting for a window to appear"):
            retry(window_is_visible)

    def sleep(self, secs: int) -> None:
        # We want to sleep in *guest* time, not *host* time.
        self.succeed(f"sleep {secs}")

    def forward_port(self, host_port: int = 8080, guest_port: int = 80) -> None:
        """Forward a TCP port on the host to a TCP port on the guest.
        Useful during interactive testing.
        """
        self.send_monitor_command(
            "hostfwd_add tcp::{}-:{}".format(host_port, guest_port)
        )

    def block(self) -> None:
        """Make the machine unreachable by shutting down eth1 (the multicast
        interface used to talk to the other VMs).  We keep eth0 up so that
        the test driver can continue to talk to the machine.
        """
        self.send_monitor_command("set_link virtio-net-pci.1 off")

    def unblock(self) -> None:
        """Make the machine reachable."""
        self.send_monitor_command("set_link virtio-net-pci.1 on")

    def release(self) -> None:
        if self.pid is None:
            return
        rootlog.info(f"kill machine (pid {self.pid})")
        assert self.process
        assert self.shell
        assert self.monitor
        assert self.serial_thread

        self.process.terminate()
        self.shell.close()
        self.monitor.close()
        self.serial_thread.join()


class VLan:
    """This class handles a VLAN that the run-vm scripts identify via its
    number handles. The network's lifetime equals the object's lifetime.
    """

    nr: int
    socket_dir: pathlib.Path

    process: subprocess.Popen
    pid: int
    fd: io.TextIOBase

    def __repr__(self) -> str:
        return f"<Vlan Nr. {self.nr}>"

    def __init__(self, nr: int, tmp_dir: pathlib.Path):
        self.nr = nr
        self.socket_dir = tmp_dir / f"vde{self.nr}.ctl"

        # TODO: don't side-effect environment here
        os.environ[f"QEMU_VDE_SOCKET_{self.nr}"] = str(self.socket_dir)

        rootlog.info("start vlan")
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
            rootlog.error("cannot start vde_switch")

        rootlog.info(f"running vlan (pid {self.pid})")

    def __del__(self) -> None:
        rootlog.info(f"kill vlan (pid {self.pid})")
        self.fd.close()
        self.process.terminate()


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

        tmp_dir = pathlib.Path(os.environ.get("TMPDIR", tempfile.gettempdir()))
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
        machine_symbols = {
            m.name: self.machines[idx] for idx, m in enumerate(self.machines)
        }
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
        tmp_dir = pathlib.Path(os.environ.get("TMPDIR", tempfile.gettempdir()))
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


class EnvDefault(argparse.Action):
    """An argpars Action that takes values from the specified
    environment variable as the flags default value.
    """

    def __init__(self, envvar, required=False, default=None, nargs=None, **kwargs):  # type: ignore
        if not default and envvar:
            if envvar in os.environ:
                if nargs is not None and (nargs.isdigit() or nargs in ["*", "+"]):
                    default = os.environ[envvar].split()
                else:
                    default = os.environ[envvar]
                kwargs["help"] = (
                    kwargs["help"] + f" (default from environment: {default})"
                )
        if required and default:
            required = False
        super(EnvDefault, self).__init__(
            default=default, required=required, nargs=nargs, **kwargs
        )

    def __call__(self, parser, namespace, values, option_string=None):  # type: ignore
        setattr(namespace, self.dest, values)


if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(prog="nixos-test-driver")
    arg_parser.add_argument(
        "-K",
        "--keep-vm-state",
        help="re-use a VM state coming from a previous run",
        action="store_true",
    )
    arg_parser.add_argument(
        "-I",
        "--interactive",
        help="drop into a python repl and run the tests interactively",
        action="store_true",
    )
    arg_parser.add_argument(
        "--start-scripts",
        metavar="START-SCRIPT",
        action=EnvDefault,
        envvar="startScripts",
        nargs="*",
        help="start scripts for participating virtual machines",
    )
    arg_parser.add_argument(
        "--vlans",
        metavar="VLAN",
        action=EnvDefault,
        envvar="vlans",
        nargs="*",
        help="vlans to span by the driver",
    )
    arg_parser.add_argument(
        "testscript",
        action=EnvDefault,
        envvar="testScript",
        help="the test script to run",
        type=pathlib.Path,
    )

    args = arg_parser.parse_args()

    if not args.keep_vm_state:
        rootlog.info("Machine state will be reset. To keep it, pass --keep-vm-state")

    with Driver(
        args.start_scripts, args.vlans, args.testscript.read_text(), args.keep_vm_state
    ) as driver:
        if args.interactive:
            ptpython.repl.embed(driver.test_symbols(), {})
        else:
            tic = time.time()
            driver.run_tests()
            toc = time.time()
            rootlog.info(f"test script finished in {(toc-tic):.2f}s")
