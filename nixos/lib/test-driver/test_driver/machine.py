from contextlib import _GeneratorContextManager, nullcontext
from pathlib import Path
from queue import Queue
from typing import Any, Callable, Dict, Iterable, List, Optional, Tuple
import base64
import io
import os
import queue
import re
import shlex
import shutil
import socket
import subprocess
import sys
import tempfile
import threading
import time

from test_driver.logger import rootlog

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

    cmd = f"convert {magick_args} '{screenshot_path}' 'tiff:{screenshot_path}.tiff'"
    ret = subprocess.run(cmd, shell=True, capture_output=True)
    if ret.returncode != 0:
        raise Exception(f"TIFF conversion failed with exit code {ret.returncode}")

    model_results = []
    for model_id in model_ids:
        cmd = f"tesseract '{screenshot_path}.tiff' - {tess_args} --oem '{model_id}'"
        ret = subprocess.run(cmd, shell=True, capture_output=True)
        if ret.returncode != 0:
            raise Exception(f"OCR failed with exit code {ret.returncode}")
        model_results.append(ret.stdout.decode("utf-8"))

    return model_results


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


class StartCommand:
    """The Base Start Command knows how to append the necesary
    runtime qemu options as determined by a particular test driver
    run. Any such start command is expected to happily receive and
    append additional qemu args.
    """

    _cmd: str

    def cmd(
        self,
        monitor_socket_path: Path,
        shell_socket_path: Path,
        allow_reboot: bool = False,
    ) -> str:
        display_opts = ""
        display_available = any(x in os.environ for x in ["DISPLAY", "WAYLAND_DISPLAY"])
        if not display_available:
            display_opts += " -nographic"

        # qemu options
        qemu_opts = (
            " -device virtio-serial"
            " -device virtconsole,chardev=shell"
            " -device virtio-rng-pci"
            " -serial stdio"
        )
        if not allow_reboot:
            qemu_opts += " -no-reboot"
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
        state_dir: Path,
        shared_dir: Path,
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
        state_dir: Path,
        shared_dir: Path,
        monitor_socket_path: Path,
        shell_socket_path: Path,
        allow_reboot: bool,
    ) -> subprocess.Popen:
        return subprocess.Popen(
            self.cmd(monitor_socket_path, shell_socket_path, allow_reboot),
            stdin=subprocess.PIPE,
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
        hda: Optional[Tuple[Path, str]] = None,
        cdrom: Optional[str] = None,
        usb: Optional[str] = None,
        bios: Optional[str] = None,
        qemuBinary: Optional[str] = None,
        qemuFlags: Optional[str] = None,
    ):
        if qemuBinary is not None:
            self._cmd = qemuBinary
        else:
            self._cmd = "qemu-kvm"

        self._cmd += " -m 384"

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
    out_dir: Path
    tmp_dir: Path
    shared_dir: Path
    state_dir: Path
    monitor_path: Path
    shell_path: Path

    start_command: StartCommand
    keep_vm_state: bool

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
    callbacks: List[Callable]

    def __repr__(self) -> str:
        return f"<Machine '{self.name}'>"

    def __init__(
        self,
        out_dir: Path,
        tmp_dir: Path,
        start_command: StartCommand,
        name: str = "machine",
        keep_vm_state: bool = False,
        callbacks: Optional[List[Callable]] = None,
    ) -> None:
        self.out_dir = out_dir
        self.tmp_dir = tmp_dir
        self.keep_vm_state = keep_vm_state
        self.name = name
        self.start_command = start_command
        self.callbacks = callbacks if callbacks is not None else []

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
            hda_arg_path: Path = Path(hda_arg)
            hda = (hda_arg_path, args.get("hdaInterface", ""))
        return LegacyStartCommand(
            netBackendArgs=args.get("netBackendArgs"),
            netFrontendArgs=args.get("netFrontendArgs"),
            hda=hda,
            cdrom=args.get("cdrom"),
            usb=args.get("usb"),
            bios=args.get("bios"),
            qemuBinary=args.get("qemuBinary"),
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
        self.run_callbacks()
        message = f"{command}\n".encode()
        assert self.monitor is not None
        self.monitor.send(message)
        return self.wait_for_monitor_prompt()

    def wait_for_unit(
        self, unit: str, user: Optional[str] = None, timeout: int = 900
    ) -> None:
        """Wait for a systemd unit to get into "active" state.
        Throws exceptions on "failed" and "inactive" states as well as
        after timing out.
        """

        def check_active(_: Any) -> bool:
            info = self.get_unit_info(unit, user)
            state = info["ActiveState"]
            if state == "failed":
                raise Exception(f'unit "{unit}" reached state "{state}"')

            if state == "inactive":
                status, jobs = self.systemctl("list-jobs --full 2>&1", user)
                if "No jobs" in jobs:
                    info = self.get_unit_info(unit, user)
                    if info["ActiveState"] == state:
                        raise Exception(
                            f'unit "{unit}" is inactive and there are no pending jobs'
                        )

            return state == "active"

        with self.nested(
            f"waiting for unit {unit}"
            + (f" with user {user}" if user is not None else "")
        ):
            retry(check_active, timeout)

    def get_unit_info(self, unit: str, user: Optional[str] = None) -> Dict[str, str]:
        status, lines = self.systemctl(f'--no-pager show "{unit}"', user)
        if status != 0:
            raise Exception(
                f'retrieving systemctl info for unit "{unit}"'
                + ("" if user is None else f' under user "{user}"')
                + f" failed with exit code {status}"
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
                f"su -l {user} --shell /bin/sh -c "
                "$'XDG_RUNTIME_DIR=/run/user/`id -u` "
                f"systemctl --user {q}'"
            )
        return self.execute(f"systemctl {q}")

    def require_unit_state(self, unit: str, require_state: str = "active") -> None:
        with self.nested(
            f"checking if unit '{unit}' has reached state '{require_state}'"
        ):
            info = self.get_unit_info(unit)
            state = info["ActiveState"]
            if state != require_state:
                raise Exception(
                    f"Expected unit '{unit}' to to be in state "
                    f"'{require_state}' but it is in state '{state}'"
                )

    def _next_newline_closed_block_from_shell(self) -> str:
        assert self.shell
        output_buffer = []
        while True:
            # This receives up to 4096 bytes from the socket
            chunk = self.shell.recv(4096)
            if not chunk:
                # Probably a broken pipe, return the output we have
                break

            decoded = chunk.decode()
            output_buffer += [decoded]
            if decoded[-1] == "\n":
                break
        return "".join(output_buffer)

    def execute(
        self, command: str, check_return: bool = True, timeout: Optional[int] = 900
    ) -> Tuple[int, str]:
        self.run_callbacks()
        self.connect()

        # Always run command with shell opts
        command = f"set -euo pipefail; {command}"

        timeout_str = ""
        if timeout is not None:
            timeout_str = f"timeout {timeout}"

        out_command = (
            f"{timeout_str} sh -c {shlex.quote(command)} | (base64 --wrap 0; echo)\n"
        )

        assert self.shell
        self.shell.send(out_command.encode())

        # Get the output
        output = base64.b64decode(self._next_newline_closed_block_from_shell())

        if not check_return:
            return (-1, output.decode())

        # Get the return code
        self.shell.send("echo ${PIPESTATUS[0]}\n".encode())
        rc = int(self._next_newline_closed_block_from_shell().strip())

        return (rc, output.decode(errors="replace"))

    def shell_interact(self, address: Optional[str] = None) -> None:
        """Allows you to interact with the guest shell for debugging purposes.

        @address string passed to socat that will be connected to the guest shell.
        Check the `Running Tests interactivly` chapter of NixOS manual for an example.
        """
        self.connect()

        if address is None:
            address = "READLINE,prompt=$ "
            self.log("Terminal is ready (there is no initial prompt):")

        assert self.shell
        try:
            subprocess.run(
                ["socat", address, f"FD:{self.shell.fileno()}"],
                pass_fds=[self.shell.fileno()],
            )
            # allow users to cancel this command without breaking the test
        except KeyboardInterrupt:
            pass

    def console_interact(self) -> None:
        """Allows you to interact with QEMU's stdin

        The shell can be exited with Ctrl+D. Note that Ctrl+C is not allowed to be used.
        QEMU's stdout is read line-wise.

        Should only be used during test development, not in the production test."""
        self.log("Terminal is ready (there is no prompt):")

        assert self.process
        assert self.process.stdin

        while True:
            try:
                char = sys.stdin.buffer.read(1)
            except KeyboardInterrupt:
                break
            if char == b"":  # ctrl+d
                self.log("Closing connection to the console")
                break
            self.send_console(char.decode())

    def succeed(self, *commands: str, timeout: Optional[int] = None) -> str:
        """Execute each command and check that it succeeds."""
        output = ""
        for command in commands:
            with self.nested(f"must succeed: {command}"):
                (status, out) = self.execute(command, timeout=timeout)
                if status != 0:
                    self.log(f"output: {out}")
                    raise Exception(f"command `{command}` failed (exit code {status})")
                output += out
        return output

    def fail(self, *commands: str, timeout: Optional[int] = None) -> str:
        """Execute each command and check that it fails."""
        output = ""
        for command in commands:
            with self.nested(f"must fail: {command}"):
                (status, out) = self.execute(command, timeout=timeout)
                if status == 0:
                    raise Exception(f"command `{command}` unexpectedly succeeded")
                output += out
        return output

    def wait_until_succeeds(self, command: str, timeout: int = 900) -> str:
        """Wait until a command returns success and return its output.
        Throws an exception on timeout.
        """
        output = ""

        def check_success(_: Any) -> bool:
            nonlocal output
            status, output = self.execute(command, timeout=timeout)
            return status == 0

        with self.nested(f"waiting for success: {command}"):
            retry(check_success, timeout)
            return output

    def wait_until_fails(self, command: str, timeout: int = 900) -> str:
        """Wait until a command returns failure.
        Throws an exception on timeout.
        """
        output = ""

        def check_failure(_: Any) -> bool:
            nonlocal output
            status, output = self.execute(command, timeout=timeout)
            return status != 0

        with self.nested(f"waiting for failure: {command}"):
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
            f"fold -w$(stty -F /dev/tty{tty} size | "
            f"awk '{{print $2}}') /dev/vcs{tty}"
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

        with self.nested(f"waiting for {regexp} to appear on tty {tty}"):
            retry(tty_matches)

    def send_chars(self, chars: str, delay: Optional[float] = 0.01) -> None:
        with self.nested(f"sending keys {repr(chars)}"):
            for char in chars:
                self.send_key(char, delay, log=False)

    def wait_for_file(self, filename: str) -> None:
        """Waits until the file exists in machine's file system."""

        def check_file(_: Any) -> bool:
            status, _ = self.execute(f"test -e {filename}")
            return status == 0

        with self.nested(f"waiting for file '{filename}'"):
            retry(check_file)

    def wait_for_open_port(self, port: int, addr: str = "localhost") -> None:
        def port_is_open(_: Any) -> bool:
            status, _ = self.execute(f"nc -z {addr} {port}")
            return status == 0

        with self.nested(f"waiting for TCP port {port} on {addr}"):
            retry(port_is_open)

    def wait_for_closed_port(self, port: int, addr: str = "localhost") -> None:
        def port_is_closed(_: Any) -> bool:
            status, _ = self.execute(f"nc -z {addr} {port}")
            return status != 0

        with self.nested(f"waiting for TCP port {port} on {addr} to be closed"):
            retry(port_is_closed)

    def start_job(self, jobname: str, user: Optional[str] = None) -> Tuple[int, str]:
        return self.systemctl(f"start {jobname}", user)

    def stop_job(self, jobname: str, user: Optional[str] = None) -> Tuple[int, str]:
        return self.systemctl(f"stop {jobname}", user)

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
            self.log(f"(connecting took {toc - tic:.2f} seconds)")
            self.connected = True

    def screenshot(self, filename: str) -> None:
        if "." not in filename:
            filename += ".png"
        if "/" not in filename:
            filename = os.path.join(self.out_dir, filename)
        tmp = f"{filename}.ppm"

        with self.nested(
            f"making screenshot {filename}",
            {"image": os.path.basename(filename)},
        ):
            self.send_monitor_command(f"screendump {tmp}")
            ret = subprocess.run(f"pnmtopng '{tmp}' > '{filename}'", shell=True)
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
        host_src = Path(source)
        vm_target = Path(target)
        with tempfile.TemporaryDirectory(dir=self.shared_dir) as shared_td:
            shared_temp = Path(shared_td)
            host_intermediate = shared_temp / host_src.name
            vm_shared_temp = Path("/tmp/shared") / shared_temp.name
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
        vm_src = Path(source)
        with tempfile.TemporaryDirectory(dir=self.shared_dir) as shared_td:
            shared_temp = Path(shared_td)
            vm_shared_temp = Path("/tmp/shared") / shared_temp.name
            vm_intermediate = vm_shared_temp / vm_src.name
            intermediate = shared_temp / vm_src.name
            # Copy the file to the shared directory inside VM
            self.succeed(make_command(["mkdir", "-p", vm_shared_temp]))
            self.succeed(make_command(["cp", "-r", vm_src, vm_intermediate]))
            abs_target = self.out_dir / target_dir / vm_src.name
            abs_target.parent.mkdir(exist_ok=True, parents=True)
            # Copy the file from the shared directory outside VM
            if intermediate.is_dir():
                shutil.copytree(intermediate, abs_target)
            else:
                shutil.copy(intermediate, abs_target)

    def dump_tty_contents(self, tty: str) -> None:
        """Debugging: Dump the contents of the TTY<n>"""
        self.execute(f"fold -w 80 /dev/vcs{tty} | systemd-cat")

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
                self.log(f"Last OCR attempt failed. Text was: {variants}")

            return False

        with self.nested(f"waiting for {regex} to appear on screen"):
            retry(screen_matches)

    def wait_for_console_text(self, regex: str) -> None:
        with self.nested(f"waiting for {regex} to appear on console"):
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

    def send_key(
        self, key: str, delay: Optional[float] = 0.01, log: Optional[bool] = True
    ) -> None:
        key = CHAR_TO_KEY.get(key, key)
        context = self.nested(f"sending key {repr(key)}") if log else nullcontext()
        with context:
            self.send_monitor_command(f"sendkey {key}")
            if delay is not None:
                time.sleep(delay)

    def send_console(self, chars: str) -> None:
        assert self.process
        assert self.process.stdin
        self.process.stdin.write(chars.encode())
        self.process.stdin.flush()

    def start(self, allow_reboot: bool = False) -> None:
        if self.booted:
            return

        self.log("starting vm")

        def clear(path: Path) -> Path:
            if path.exists():
                path.unlink()
            return path

        def create_socket(path: Path) -> socket.socket:
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
            allow_reboot,
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

        self.log(f"QEMU running (pid {self.pid})")

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

    def reboot(self) -> None:
        """Press Ctrl+Alt+Delete in the guest.

        Prepares the machine to be reconnected which is useful if the
        machine was started with `allow_reboot = True`
        """
        self.send_key(f"ctrl-alt-delete")
        self.connected = False

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
                    f"Last chance to match {regexp} on the window list,"
                    + " which currently contains: "
                    + ", ".join(names)
                )
            return any(pattern.search(name) for name in names)

        with self.nested("waiting for a window to appear"):
            retry(window_is_visible)

    def sleep(self, secs: int) -> None:
        # We want to sleep in *guest* time, not *host* time.
        self.succeed(f"sleep {secs}")

    def forward_port(self, host_port: int = 8080, guest_port: int = 80) -> None:
        """Forward a TCP port on the host to a TCP port on the guest.
        Useful during interactive testing.
        """
        self.send_monitor_command(f"hostfwd_add tcp::{host_port}-:{guest_port}")

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

    def run_callbacks(self) -> None:
        for callback in self.callbacks:
            callback()
