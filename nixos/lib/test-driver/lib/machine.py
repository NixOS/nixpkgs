from contextlib import contextmanager, _GeneratorContextManager
from queue import Queue
from typing import Tuple, Any, Callable, Dict, Optional, List, Iterable
import queue
import io
import _thread
import base64
import os
import pathlib
import re
import shlex
import shutil
import socket
import subprocess
import sys
import tempfile
import telnetlib
import time

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


class BaseStartCommand:
    def __init__(self):
        pass

    def cmd(
        self,
        monitor_socket_path: str,
        shell_socket_path: str,
        allow_reboot: bool = False,  # TODO: unused, legacy?
        tty_path: Optional[str] = None,  # TODO: currently unused
    ):
        tty_opts = ""
        if tty_path is not None:
            tty_opts += (
                f" -chardev socket,server,nowait,id=console,path={tty_path}"
                " -device virtconsole,chardev=console"
            )
        display_opts = ""
        display_available = any(
            x in os.environ for x in ["DISPLAY", "WAYLAND_DISPLAY"])
        if display_available:
            display_opts += " -nographic"

        # qemu options
        qemu_opts = ""
        qemu_opts += (
            "" if allow_reboot else " -no-reboot"
            " -device virtio-serial"
            " -device virtconsole,chardev=shell"
            " -serial stdio"
        )
        # TODO: qemu script already catpures this env variable, legacy?
        qemu_opts += " " + os.environ.get("QEMU_OPTS", "")

        return (
            f"{self._cmd}"
            f" -monitor unix:{monitor_socket_path}"
            f" -chardev socket,id=shell,path={shell_socket_path}"
            f"{tty_opts}{display_opts}"
        )

    def build_environment(
        state_dir: str,
        shared_dir: str,
    ):
        return dict(os.environ).update(
            {
                "TMPDIR": state_dir,
                "SHARED_DIR": shared_dir,
                "USE_TMPDIR": "1",
            }
        )

    def run(
        self,
        state_dir: str,
        shared_dir: str,
        monitor_socket_path: str,
        shell_socket_path: str,
    ):
        return subprocess.Popen(
            self.cmd(monitor_socket_path, shell_socket_path),
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            shell=True,
            cwd=state_dir,
            env=self.build_environment(state_dir, shared_dir),
        )


class NixStartScript(BaseStartCommand):
    """ accepts a start script from nixos/modules/virtualiation/qemu-vm.nix

    Note, that appended flags in self.cmd are are passed to the qemu
    bin by the script's final "${@}"
    """

    def __init__(self, script: str):
        self._cmd = script

    @property
    def machine_name():
        match = re.search("run-(.+)-vm$", self._cmd)
        name = "machine"
        if match:
            name = match.group(1)
        return name


class StartCommand(BaseStartCommand):
    """ unused, legacy?
    """

    def __init__(
        self,
        allow_reboot: bool = False,
        tty_path: Optional[str] = None,
        netBackendArgs: Optional[str] = None,
        netFrontendArgs: Optional[str] = None,
        hda: Optional[Tuple[str, str]] = None,
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
        self.cmd += f" {net_backend} {net_frontend}"

        # hda
        hda_cmd = ""
        if hda is not None:
            hda_path = os.path.abspath(hda[0])
            hda_interface = hda[1]
            if hda_interface == "scsi":
                hda_cmd += (
                   f" -drive id=hda,file={hda_path},werror=report,if=none"
                   " -device scsi-hd,drive=hda"
                )
            else:
                hda_cmd += (
                    f" -drive file={hda_path},if={hda_interface},werror=report"
                )
        self.cmd += hda_cmd

        # cdrom
        if cdrom is not None:
            self.cmd += f" -cdrom {cdrom}"

        # usb
        usb_cmd = ""
        if usb is not None:
            # https://github.com/qemu/qemu/blob/master/docs/usb2.txt
            usb_cmd += (
                " -device usb-ehci"
                f" -drive id=usbdisk,file={usb},if=none,readonly"
                "-device usb-storage,drive=usbdisk "
            )
        self.cmd += usb_cmd

        # bios
        if bios is not None:
            self.cmd += f" -bios {bios}"

        # qemu flags
        if qemuFlags is not None:
            self.cmd += f" {qemuFlags}"


class Machine:
    def __init__(
        self,
        log_serial: Callable,
        log_machinestate: Callable,
        tmp_dir: str,
        name: str = "machine",
        start_command: StartCommand = StartCommand(),
        keep_vm_state: bool = False,
        allow_reboot: bool = False,
    ) -> None:
        self.log_serial = lambda msg: log_serial(
            f"[{name} LOG] {msg}", {"machine": name})
        self.log_machinestate = lambda msg: log_machinestate(
            f"[{name} MCS] {msg}", {"machine": name})
        self.tmp_dir = tmp_dir
        self.keep_vm_state = keep_vm_state
        self.allow_reboot = allow_reboot
        self.name = name
        self.start_command = start_command

        # in order to both enable plain log functions, but also nested
        # machine state logging, check if the `log_machinestate` object
        # has a method `nested` and provide this functionality.
        # Ideally, just remove this logic long term and make it as  easy as
        # possible for the user of `Machine` to provide plain standard loggers
        @contextmanager
        def dummy_nest(message: str) -> _GeneratorContextManager:
            self.log_machinestate(message)
            yield

        nest_op = getattr(self.log_machinestate, "nested", None)
        if callable(nest_op):
            self.nested = nest_op
        else:
            self.nested = dummy_nest

        # set up directories
        self.shared_dir = os.path.join(self.tmp_dir, "shared-xchg")
        os.makedirs(self.shared_dir, mode=0o700, exist_ok=True)

        self.state_dir = os.path.join(self.tmp_dir, f"vm-state-{self.name}")
        self.monitor_path = os.path.join(self.state_dir, "monitor")
        self.shell_path = os.path.join(self.state_dir, "shell")
        if (not self.keep_vm_state) and os.path.isdir(self.state_dir):
            shutil.rmtree(self.state_dir)
            self.log_machinestate(
               f"deleting VM state directory {self.state_dir}\n"
               "if you want to keep the VM state, pass --keep-vm-state"
            )
        os.makedirs(self.state_dir, mode=0o700, exist_ok=True)

        self.process: Optional[subprocess.Popen] = None
        self.pid: Optional[int] = None
        self.monitor: Optional[socket.socket] = None
        self.shell: Optional[socket.socket] = None

        self.booted = False
        self.connected = False
        # Store last serial console lines for use
        # of wait_for_console_text
        self.last_lines: Queue = Queue()

    def _wait_for_monitor_prompt(self) -> str:
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

    def _wait_for_shutdown(self) -> None:
        if not self.booted:
            return

        with self.nested("waiting for the VM to power off"):
            sys.stdout.flush()
            self.process.wait()

            self.pid = None
            self.booted = False
            self.connected = False

    def start(self) -> None:
        if self.booted:
            return

        self.log_machinestate("starting vm")

        def clear(path: str):
            if os.path.exists(path):
                os.unlink(path)
            return path

        def create_socket(path: str) -> socket.socket:
            s = socket.socket(family=socket.AF_UNIX, type=socket.SOCK_STREAM)
            s.bind(path)
            s.listen(1)
            return s

        monitor_socket = create_socket(clear(self.monitor_path))
        shell_socket = create_socket(clear(self.shell_path))
        self.process = self.start_command.run(
            self.state_dir, self.shared_dir,
            self.monitor_path, self.shell_path,
        )
        self.monitor, _ = monitor_socket.accept()
        self.shell, _ = shell_socket.accept()

        def process_serial_output() -> None:
            assert self.process.stdout is not None
            for _line in self.process.stdout:
                # Ignore undecodable bytes that may occur in boot menus
                line = _line.decode(errors="ignore").replace("\r", "").rstrip()
                self.last_lines.put(line)
                self.log_serial(line)

        _thread.start_new_thread(process_serial_output, ())

        self._wait_for_monitor_prompt()

        self.pid = self.process.pid
        self.booted = True

        self.log_machinestate(f"QEMU running (pid {self.pid})")

    def release(self) -> bool:
        if self.pid is None:
            return False
        self.process.kill()
        return True

    def connect(self) -> None:
        if self.connected:
            return

        with self.nested("waiting for the VM to finish booting"):
            self.start()

            tic = time.time()
            self.shell.recv(1024)
            # TODO: Timeout
            toc = time.time()

            self.log_machinestate("connected to guest root shell")
            self.log_machinestate("(connecting took {:.2f} seconds)".format(toc - tic))
            self.connected = True

    def shutdown(self) -> None:
        if not self.booted:
            return

        self.log_machinestate("regular shutdown")
        self.shell.send("poweroff\n".encode())
        self._wait_for_shutdown()

    def crash(self) -> None:
        if not self.booted:
            return

        self.log_machinestate("forced crash")
        self.send_monitor_command("quit")
        self._wait_for_shutdown()

    def block(self) -> None:
        """Make the machine unreachable by shutting down eth1 (the multicast
        interface used to talk to the other VMs).  We keep eth0 up so that
        the test driver can continue to talk to the machine.
        """
        self.send_monitor_command("set_link virtio-net-pci.1 off")

    def unblock(self) -> None:
        """Make the machine reachable.
        """
        self.send_monitor_command("set_link virtio-net-pci.1 on")

    def is_up(self) -> bool:
        return self.booted and self.connected

    def send_monitor_command(self, command: str) -> str:
        message = ("{}\n".format(command)).encode()
        self.log_machinestate("sending monitor command: {}".format(command))
        assert self.monitor is not None
        self.monitor.send(message)
        return self._wait_for_monitor_prompt()

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

        out_command = "( {} ); echo '|!=EOF' $?\n".format(command)
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
        Should only be used during testing, not in the production test."""
        self.connect()
        assert self.shell
        telnet = telnetlib.Telnet()
        telnet.sock = self.shell
        telnet.interact()

    def succeed(self, *commands: str) -> str:
        """Execute each command and check that it succeeds."""
        output = ""
        for command in commands:
            with self.nested("must succeed: {}".format(command)):
                status, out = self.execute(command)
                if status != 0:
                    self.log_machinestate("output: {}".format(out))
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

    def wait_until_succeeds(self, command: str) -> str:
        """Wait until a command returns success and return its output.
        Throws an exception on timeout.
        """
        output = ""

        def check_success(_: Any) -> bool:
            nonlocal output
            status, output = self.execute(command)
            return status == 0

        with self.nested("waiting for success: {}".format(command)):
            retry(check_success)
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
                self.log_machinestate(
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
        """Debugging: Dump the contents of the TTY<n>
        """
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
                self.log_machinestate("Last OCR attempt failed. Text was: {}".format(variants))

            return False

        with self.nested("waiting for {} to appear on screen".format(regex)):
            retry(screen_matches)

    def wait_for_console_text(self, regex: str) -> None:
        self.log_machinestate("waiting for {} to appear on console".format(regex))
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
                self.log_machinestate(
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
