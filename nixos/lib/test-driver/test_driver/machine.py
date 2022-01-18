from contextlib import _GeneratorContextManager, suppress
from pathlib import Path
from queue import Queue
from typing import Any, Callable, Dict, Iterable, List, Optional, Tuple, Union
import base64
import bashlex
import io
import os
import queue
import re
import shlex
import shutil
import select
import socket
import string
import subprocess
import sys
import tempfile
import threading
import time

from test_driver.logger import rootlog

DEFAULT_TIMEOUT = 900
CHAR_TO_KEY = {
    '"': "shift-0x28",
    " ": "spc",
    "_": "shift-0x0C",
    "-": "0x0C",
    ",": "0x33",
    ";": "0x27",
    ":": "shift-0x27",
    "?": "shift-0x35",
    ".": "0x34",
    "'": "0x28",
    "[": "0x1A",
    "]": "0x1B",
    "{": "shift-0x1A",
    "}": "shift-0x1B",
    "/": "0x35",
    "\\": "0x2B",
    "\n": "ret",
    "`": "0x29",
    "<": "shift-0x33",
    "=": "0x0D",
    ">": "shift-0x34",
    "|": "shift-0x2B",
    "~": "shift-0x29",
    # Top row (shift  + '0'-'9', '-', and '='):
    **{c: f"shift-0x{i:02x}" for i, c in enumerate("!@#$%^&*()_+", start=2)},
    # Capital letters:
    **{c.upper(): f"shift-{c}" for c in string.ascii_lowercase},
}

assert all(len(c) == 1 for c in CHAR_TO_KEY.keys())


def q(s: Union[str, Path]) -> str:
    return shlex.quote(str(s))


def _perform_ocr_on_screenshot(
    screenshot_path: str, model_ids: Iterable[int]
) -> List[str]:
    if shutil.which("tesseract") is None:
        raise Exception("OCR requested but enableOCR is false")

    magick_args = (
        "-filter Catrom -density 72 -resample 300 "
        "-contrast -normalize -despeckle -type grayscale "
        "-sharpen 1 -posterize 3 -negate -gamma 100 "
        "-blur 1x65535"
    )

    tess_args = "-c debug_file=/dev/null --psm 11"

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


def retry(fn: Callable, timeout: int = DEFAULT_TIMEOUT) -> Any:
    """Call the given function repeatedly, with 1 second intervals,
    until it returns a truthy value or a timeout is reached.
    """

    for n in range(timeout + 1):
        r = fn(n == timeout)
        if r:
            return r
        time.sleep(1)
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
    ) -> str:
        display_opts = ""
        display_available = any(x in os.environ for x in ["DISPLAY", "WAYLAND_DISPLAY"])
        if not display_available:
            display_opts += " -nographic"

        # qemu options
        qemu_opts = (
            " -no-reboot"
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
            f" -chardev socket,id=shell,path={q(shell_socket_path)}"
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
        hda: Optional[Tuple[Path, str]] = None,
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
        with self.nested("waiting for monitor prompt"):
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
        with self.nested(f"sending monitor command: {command}"):
            message = f"{command}\n".encode()
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
                raise Exception('unit "{unit}" reached state "{state}"')

            if state == "inactive":
                status, jobs = self.systemctl("list-jobs --full 2>&1", user)
                if "No jobs" in jobs:
                    info = self.get_unit_info(unit, user)
                    if info["ActiveState"] == state:
                        raise Exception(
                            f'unit "{unit}" is inactive and there are no pending jobs'
                        )

            return state == "active"

        msg = f"waiting for unit {unit}"
        if user is not None:
            msg += f" with user {user}"
        with self.nested(msg):
            retry(check_active)

    def get_unit_info(self, unit: str, user: Optional[str] = None) -> Dict[str, str]:
        status, lines = self.systemctl(f'--no-pager show "{unit}"', user)
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
                    f"su -l {user} --shell /bin/sh -c "
                    f"$'XDG_RUNTIME_DIR=/run/user/`id -u` "
                    f"systemctl --user {q}'"
                )
            )
        return self.execute(f"systemctl {q}")

    def require_unit_state(self, unit: str, require_state: str = "active") -> None:
        with self.nested(
            f"checking if unit ‘{unit}’ has reached state '{require_state}'"
        ):
            info = self.get_unit_info(unit)
            state = info["ActiveState"]
            if state != require_state:
                raise Exception(
                    f"Expected unit ‘{unit}’ to to be in state "
                    f"'{require_state}' but it is in state ‘{state}’"
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

    def _shell_send(self, command: str) -> str:
        command += "\n"
        assert self.shell
        self.shell.send(command.encode())
        output = self._next_newline_closed_block_from_shell()
        return output

    def execute(
        self,
        command: str,
        check_return: bool = True,
        timeout: Optional[int] = DEFAULT_TIMEOUT,
    ) -> Tuple[int, str]:
        self.run_callbacks()
        self.connect()

        with suppress(NotImplementedError):
            # This should succeed, otherwise it will raise an exception:
            bashlex.parse(command)

        if timeout is not None:
            command = f"timeout {timeout} sh -c {shlex.quote(command)}"

        command = f"( set -euo pipefail; {command} ) | (base64 --wrap 0; echo)"

        # Get the output
        output = base64.b64decode(self._shell_send(command))

        rc = -1
        if check_return:
            # Get the return code
            rc = int(self._shell_send("echo ${PIPESTATUS[0]}"))

        return (rc, output.decode())

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

    def wait_until_succeeds(self, command: str, timeout: int = DEFAULT_TIMEOUT) -> str:
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

    def wait_until_fails(self, command: str, timeout: int = DEFAULT_TIMEOUT) -> str:
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
        return self.succeed(
            f"fold -w$(stty -F /dev/tty{tty} size | "
            f"awk '{{print $2}}') /dev/vcs{tty}"
        )

    def wait_until_tty_matches(
        self, tty: str, regexp: str, timeout: int = DEFAULT_TIMEOUT
    ) -> None:
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
            return bool(matcher.search(text))

        with self.nested(f"waiting for /{regexp}/ to appear on TTY{tty}"):
            retry(tty_matches, timeout)

    def send_chars(self, chars: List[str]) -> None:
        with self.nested(f"sending keys {chars!r}"):
            for char in chars:
                self.send_key(char)

    def wait_for_file(self, filename: str, timeout: int = DEFAULT_TIMEOUT) -> None:
        """Waits until the file exists in machine's file system."""

        with self.nested(f"waiting for file ‘{filename}‘"):
            self.wait_until_succeeds(f"test -e {q(filename)}", timeout)

    def wait_for_open_port(self, port: int, timeout: int = DEFAULT_TIMEOUT) -> None:
        with self.nested(f"waiting for TCP port {port}"):
            self.wait_until_succeeds(f"nc -z localhost {port}")

    def wait_for_closed_port(self, port: int, timeout: int = DEFAULT_TIMEOUT) -> None:
        with self.nested(f"waiting for TCP port {port} to be closed"):
            self.wait_until_fails(f"nc -z localhost {port}")

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
        word_pattern = re.compile(r"^\w+$")
        if word_pattern.match(filename):
            filename = os.path.join(self.out_dir, "{}.png".format(filename))
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
                f"mkdir -p $(dirname {q(target)})",
                f"echo -n {content_b64} | base64 -d > {q(target)}",
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

            self.succeed(f"mkdir -p {q(vm_shared_temp)}")
            if host_src.is_dir():
                shutil.copytree(host_src, host_intermediate)
            else:
                shutil.copy(host_src, host_intermediate)
            self.succeed(f"mkdir -p {q(vm_target.parent)}")
            self.succeed(f"cp -r {q(vm_intermediate)} {q(vm_target)}")

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
            self.succeed(f"mkdir -p {q(vm_shared_temp)}")
            self.succeed(f"cp -r  {q(vm_src)} {q(vm_intermediate)}")
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

    def wait_for_text(self, regex: str, timeout: int = DEFAULT_TIMEOUT) -> None:
        def screen_matches(last: bool) -> bool:
            variants = self.get_screen_text_variants()
            for text in variants:
                if re.search(regex, text) is not None:
                    return True

            if last:
                self.log(f"Last OCR attempt failed. Text was: {variants}")

            return False

        with self.nested(f"waiting for /{regex}/ to appear on screen"):
            retry(screen_matches, timeout)

    def wait_for_console_text(self, regex: str, timeout: int = DEFAULT_TIMEOUT) -> None:
        with self.nested(f"waiting for /{regex}/ to appear on console"):
            # Buffer the console output, this is needed
            # to match multiline regexes.
            console = io.StringIO()

            def check_console(last: bool) -> bool:
                try:
                    console.write(self.last_lines.get())
                except queue.Empty:
                    return False
                console.seek(0)
                console_text = console.read()
                matches = re.search(regex, console_text)

                if last and matches is None:
                    self.log(f"Last console attempt failed. Text was: {console_text}")
                return matches is not None

            retry(check_console, timeout)

    def send_key(self, key: str) -> None:
        key = CHAR_TO_KEY.get(key, key)
        self.send_monitor_command(f"sendkey {key}")
        time.sleep(0.01)

    def start(self) -> None:
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
        )

        def accept(sock):  # type: ignore
            while True:
                if self.process.poll() is not None:
                    raise Exception("VM exited")
                r, w, e = select.select([sock], [], [], 1)
                for s in r:
                    return sock.accept()

        self.monitor, _ = accept(monitor_socket)
        self.shell, _ = accept(shell_socket)

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

    def wait_for_window(self, regexp: str, timeout: int = DEFAULT_TIMEOUT) -> None:
        pattern = re.compile(regexp)

        def window_is_visible(last_try: bool) -> bool:
            names = self.get_window_names()
            if last_try:
                self.log(
                    f"Last chance to match /{regexp}/ on the window list, "
                    + "which currently contains: "
                    + ", ".join(names)
                )
            return any(pattern.search(name) for name in names)

        with self.nested("waiting for a window to appear"):
            retry(window_is_visible, timeout)

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
