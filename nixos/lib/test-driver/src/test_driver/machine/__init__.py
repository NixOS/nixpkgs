import base64
import io
import os
import platform
import queue
import re
import select
import shlex
import shutil
import socket
import subprocess
import sys
import tempfile
import threading
import time
from collections.abc import Callable, Generator
from contextlib import _GeneratorContextManager, contextmanager, nullcontext
from pathlib import Path
from queue import Queue
from typing import Any

from test_driver.errors import MachineError, RequestedAssertionFailed
from test_driver.logger import AbstractLogger

from .ocr import perform_ocr_on_screenshot, perform_ocr_variants_on_screenshot
from .qmp import QMPSession

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
        raise RequestedAssertionFailed(
            f"action timed out after {timeout} tries with one-second pause in-between"
        )


class StartCommand:
    """The Base Start Command knows how to append the necessary
    runtime qemu options as determined by a particular test driver
    run. Any such start command is expected to happily receive and
    append additional qemu args.
    """

    _cmd: str

    def cmd(
        self,
        monitor_socket_path: Path,
        qmp_socket_path: Path,
        shell_socket_path: Path,
        allow_reboot: bool = False,
    ) -> str:
        display_opts = ""

        display_available = any(x in os.environ for x in ["DISPLAY", "WAYLAND_DISPLAY"])
        if platform.system() == "Darwin":
            # We have no DISPLAY variables on macOS and seemingly no better way
            # to find out
            display_available = "TERM_PROGRAM" in os.environ

        if not display_available:
            display_opts += " -nographic"

        # qemu options
        qemu_opts = (
            " -device virtio-serial"
            # Note: virtconsole will map to /dev/hvc0 in Linux guests
            " -device virtconsole,chardev=shell"
            " -device virtio-rng-pci"
            " -serial stdio"
        )
        if not allow_reboot:
            qemu_opts += " -no-reboot"

        return (
            f"{self._cmd}"
            f" -qmp unix:{qmp_socket_path},server=on,wait=off"
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
        qmp_socket_path: Path,
        shell_socket_path: Path,
        allow_reboot: bool,
    ) -> subprocess.Popen:
        return subprocess.Popen(
            self.cmd(
                monitor_socket_path, qmp_socket_path, shell_socket_path, allow_reboot
            ),
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            shell=True,
            cwd=state_dir,
            env=self.build_environment(state_dir, shared_dir),
        )


class NixStartScript(StartCommand):
    """A start script from nixos/modules/virtualiation/qemu-vm.nix.
    These Nix commands have the particular characteristic that the
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


class Machine:
    """A handle to the machine with this name, that also knows how to manage
    the machine lifecycle with the help of a start script / command."""

    name: str
    out_dir: Path
    tmp_dir: Path
    shared_dir: Path
    state_dir: Path
    monitor_path: Path
    qmp_path: Path
    shell_path: Path

    start_command: StartCommand
    keep_vm_state: bool

    process: subprocess.Popen | None
    pid: int | None
    monitor: socket.socket | None
    qmp_client: QMPSession | None
    shell: socket.socket | None
    serial_thread: threading.Thread | None

    booted: bool
    connected: bool
    # Store last serial console lines for use
    # of wait_for_console_text
    last_lines: Queue = Queue()
    # Store all console output for full log retrieval
    full_console_log: list[str]
    callbacks: list[Callable]

    def __repr__(self) -> str:
        return f"<Machine '{self.name}'>"

    def __init__(
        self,
        out_dir: Path,
        tmp_dir: Path,
        start_command: StartCommand,
        logger: AbstractLogger,
        name: str = "machine",
        keep_vm_state: bool = False,
        callbacks: list[Callable] | None = None,
    ) -> None:
        self.out_dir = out_dir
        self.tmp_dir = tmp_dir
        self.keep_vm_state = keep_vm_state
        self.name = name
        self.start_command = start_command
        self.callbacks = callbacks if callbacks is not None else []
        self.logger = logger
        self.full_console_log = []

        # set up directories
        self.shared_dir = self.tmp_dir / "shared-xchg"
        self.shared_dir.mkdir(mode=0o700, exist_ok=True)

        self.state_dir = self.tmp_dir / f"vm-state-{self.name}"
        self.monitor_path = self.state_dir / "monitor"
        self.qmp_path = self.state_dir / "qmp"
        self.shell_path = self.state_dir / "shell"
        if (not self.keep_vm_state) and self.state_dir.exists():
            self.cleanup_statedir()
        self.state_dir.mkdir(mode=0o700, exist_ok=True)

        self.process = None
        self.pid = None
        self.monitor = None
        self.qmp_client = None
        self.shell = None
        self.serial_thread = None

        self.booted = False
        self.connected = False

    def is_up(self) -> bool:
        return self.booted and self.connected

    def log(self, msg: str) -> None:
        self.logger.log(msg, {"machine": self.name})

    def log_serial(self, msg: str) -> None:
        self.logger.log_serial(msg, self.name)

    def nested(self, msg: str, attrs: dict[str, str] = {}) -> _GeneratorContextManager:
        my_attrs = {"machine": self.name}
        my_attrs.update(attrs)
        return self.logger.nested(msg, my_attrs)

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
        """
        Send a command to the QEMU monitor. This allows attaching
        virtual USB disks to a running machine, among other things.
        """
        self.run_callbacks()
        message = f"{command}\n".encode()
        assert self.monitor is not None
        self.monitor.send(message)
        return self.wait_for_monitor_prompt()

    def wait_for_unit(
        self, unit: str, user: str | None = None, timeout: int = 900
    ) -> None:
        """
        Wait for a systemd unit to get into "active" state.
        Throws exceptions on "failed" and "inactive" states as well as after
        timing out.
        """

        def check_active(_last_try: bool) -> bool:
            state = self.get_unit_property(unit, "ActiveState", user)
            if state == "failed":
                raise RequestedAssertionFailed(f'unit "{unit}" reached state "{state}"')

            if state == "inactive":
                status, jobs = self.systemctl("list-jobs --full 2>&1", user)
                if "No jobs" in jobs:
                    info = self.get_unit_info(unit, user)
                    if info["ActiveState"] == state:
                        raise RequestedAssertionFailed(
                            f'unit "{unit}" is inactive and there are no pending jobs'
                        )

            return state == "active"

        with self.nested(
            f"waiting for unit {unit}"
            + (f" with user {user}" if user is not None else "")
        ):
            retry(check_active, timeout)

    def get_unit_info(self, unit: str, user: str | None = None) -> dict[str, str]:
        status, lines = self.systemctl(f'--no-pager show "{unit}"', user)
        if status != 0:
            raise RequestedAssertionFailed(
                f'retrieving systemctl info for unit "{unit}"'
                + ("" if user is None else f' under user "{user}"')
                + f" failed with exit code {status}"
            )

        line_pattern = re.compile(r"^([^=]+)=(.*)$")

        def tuple_from_line(line: str) -> tuple[str, str]:
            match = line_pattern.match(line)
            assert match is not None
            return match[1], match[2]

        return dict(
            tuple_from_line(line)
            for line in lines.split("\n")
            if line_pattern.match(line)
        )

    def get_unit_property(
        self,
        unit: str,
        property: str,
        user: str | None = None,
    ) -> str:
        status, lines = self.systemctl(
            f'--no-pager show "{unit}" --property="{property}"',
            user,
        )
        if status != 0:
            raise RequestedAssertionFailed(
                f'retrieving systemctl property "{property}" for unit "{unit}"'
                + ("" if user is None else f' under user "{user}"')
                + f" failed with exit code {status}"
            )

        invalid_output_message = (
            f'systemctl show --property "{property}" "{unit}"'
            f"produced invalid output: {lines}"
        )

        line_pattern = re.compile(r"^([^=]+)=(.*)$")
        match = line_pattern.match(lines)
        assert match is not None, invalid_output_message

        assert match[1] == property, invalid_output_message
        return match[2]

    def systemctl(self, q: str, user: str | None = None) -> tuple[int, str]:
        """
        Runs `systemctl` commands with optional support for
        `systemctl --user`

        ```py
        # run `systemctl list-jobs --no-pager`
        machine.systemctl("list-jobs --no-pager")

        # spawn a shell for `any-user` and run
        # `systemctl --user list-jobs --no-pager`
        machine.systemctl("list-jobs --no-pager", "any-user")
        ```
        """
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
                raise RequestedAssertionFailed(
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
        self,
        command: str,
        check_return: bool = True,
        check_output: bool = True,
        timeout: int | None = 900,
    ) -> tuple[int, str]:
        """
        Execute a shell command, returning a list `(status, stdout)`.

        Commands are run with `set -euo pipefail` set:

        -   If several commands are separated by `;` and one fails, the
            command as a whole will fail.

        -   For pipelines, the last non-zero exit status will be returned
            (if there is one; otherwise zero will be returned).

        -   Dereferencing unset variables fails the command.

        -   It will wait for stdout to be closed.

        If the command detaches, it must close stdout, as `execute` will wait
        for this to consume all output reliably. This can be achieved by
        redirecting stdout to stderr `>&2`, to `/dev/console`, `/dev/null` or
        a file. Examples of detaching commands are `sleep 365d &`, where the
        shell forks a new process that can write to stdout and `xclip -i`, where
        the `xclip` command itself forks without closing stdout.

        Takes an optional parameter `check_return` that defaults to `True`.
        Setting this parameter to `False` will not check for the return code
        and return -1 instead. This can be used for commands that shut down
        the VM and would therefore break the pipe that would be used for
        retrieving the return code.

        A timeout for the command can be specified (in seconds) using the optional
        `timeout` parameter, e.g., `execute(cmd, timeout=10)` or
        `execute(cmd, timeout=None)`. The default is 900 seconds.
        """
        self.run_callbacks()
        self.connect()

        # Always run command with shell opts
        command = f"set -euo pipefail; {command}"

        timeout_str = ""
        if timeout is not None:
            timeout_str = f"timeout {timeout}"

        # While sh is bash on NixOS, this is not the case for every distro.
        # We explicitly call bash here to allow for the driver to boot other distros as well.
        out_command = (
            f"{timeout_str} bash -c {shlex.quote(command)} | (base64 -w 0; echo)\n"
        )

        assert self.shell
        self.shell.send(out_command.encode())

        if not check_output:
            return (-2, "")

        # Get the output
        output = base64.b64decode(self._next_newline_closed_block_from_shell())

        if not check_return:
            return (-1, output.decode())

        # Get the return code
        self.shell.send(b"echo ${PIPESTATUS[0]}\n")
        rc = int(self._next_newline_closed_block_from_shell().strip())

        return (rc, output.decode(errors="replace"))

    def shell_interact(self, address: str | None = None) -> None:
        """
        Allows you to directly interact with the guest shell. This should
        only be used during test development, not in production tests.
        Killing the interactive session with `Ctrl-d` or `Ctrl-c` also ends
        the guest session.
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
        """
        Allows you to directly interact with QEMU's stdin, by forwarding
        terminal input to the QEMU process.
        This is for use with the interactive test driver, not for production
        tests, which run unattended.
        Output from QEMU is only read line-wise. `Ctrl-c` kills QEMU and
        `Ctrl-d` closes console and returns to the test runner.
        """
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

    def succeed(self, *commands: str, timeout: int | None = None) -> str:
        """
        Execute a shell command, raising an exception if the exit status is
        not zero, otherwise returning the standard output. Similar to `execute`,
        except that the timeout is `None` by default. See `execute` for details on
        command execution.
        """
        output = ""
        for command in commands:
            with self.nested(f"must succeed: {command}"):
                (status, out) = self.execute(command, timeout=timeout)
                if status != 0:
                    self.log(f"output: {out}")
                    raise RequestedAssertionFailed(
                        f"command `{command}` failed (exit code {status})"
                    )
                output += out
        return output

    def fail(self, *commands: str, timeout: int | None = None) -> str:
        """
        Like `succeed`, but raising an exception if the command returns a zero
        status.
        """
        output = ""
        for command in commands:
            with self.nested(f"must fail: {command}"):
                (status, out) = self.execute(command, timeout=timeout)
                if status == 0:
                    raise RequestedAssertionFailed(
                        f"command `{command}` unexpectedly succeeded"
                    )
                output += out
        return output

    def wait_until_succeeds(self, command: str, timeout: int = 900) -> str:
        """
        Repeat a shell command with 1-second intervals until it succeeds.
        Has a default timeout of 900 seconds which can be modified, e.g.
        `wait_until_succeeds(cmd, timeout=10)`. See `execute` for details on
        command execution.
        Throws an exception on timeout.
        """
        output = ""

        def check_success(_last_try: bool) -> bool:
            nonlocal output
            status, output = self.execute(command, timeout=timeout)
            return status == 0

        with self.nested(f"waiting for success: {command}"):
            retry(check_success, timeout)
            return output

    def wait_until_fails(self, command: str, timeout: int = 900) -> str:
        """
        Like `wait_until_succeeds`, but repeating the command until it fails.
        """
        output = ""

        def check_failure(_last_try: bool) -> bool:
            nonlocal output
            status, output = self.execute(command, timeout=timeout)
            return status != 0

        with self.nested(f"waiting for failure: {command}"):
            retry(check_failure, timeout)
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

    def wait_for_qmp_event(
        self, event_filter: Callable[[dict[str, Any]], bool], timeout: int = 60 * 10
    ) -> dict[str, Any]:
        """
        Wait for a QMP event which you can filter with the `event_filter` function.
        The function takes as an input a dictionary of the event and if it returns True, we return that event,
        if it does not, we wait for the next event and retry.

        It will skip all events received in the meantime, if you want to keep them,
        you have to do the bookkeeping yourself and store them somewhere.

        By default, it will wait up to 10 minutes, `timeout` is in seconds.
        """
        if self.qmp_client is None:
            raise RuntimeError("QMP API is not ready yet, is the VM ready?")

        start = time.time()
        while True:
            evt = self.qmp_client.wait_for_event(timeout=timeout)
            if event_filter(evt):
                return evt

            elapsed = time.time() - start
            if elapsed >= timeout:
                raise TimeoutError

    def get_tty_text(self, tty: str) -> str:
        status, output = self.execute(
            f"fold -w$(stty -F /dev/tty{tty} size | awk '{{print $2}}') /dev/vcs{tty}"
        )
        return output

    def wait_until_tty_matches(self, tty: str, regexp: str, timeout: int = 900) -> None:
        """Wait until the visible output on the chosen TTY matches regular
        expression. Throws an exception on timeout.
        """
        matcher = re.compile(regexp)

        def tty_matches(last_try: bool) -> bool:
            text = self.get_tty_text(tty)
            if last_try:
                self.log(
                    f"Last chance to match /{regexp}/ on TTY{tty}, "
                    f"which currently contains: {text}"
                )
            return len(matcher.findall(text)) > 0

        with self.nested(f"waiting for {regexp} to appear on tty {tty}"):
            retry(tty_matches, timeout)

    def send_chars(self, chars: str, delay: float | None = 0.01) -> None:
        r"""
        Simulate typing a sequence of characters on the virtual keyboard,
        e.g., `send_chars("foobar\n")` will type the string `foobar`
        followed by the Enter key.
        """
        with self.nested(f"sending keys {repr(chars)}"):
            for char in chars:
                self.send_key(char, delay, log=False)

    def wait_for_file(self, filename: str, timeout: int = 900) -> None:
        """
        Waits until the file exists in the machine's file system.
        """

        def check_file(_last_try: bool) -> bool:
            status, _ = self.execute(f"test -e {filename}")
            return status == 0

        with self.nested(f"waiting for file '{filename}'"):
            retry(check_file, timeout)

    def wait_for_open_port(
        self, port: int, addr: str = "localhost", timeout: int = 900
    ) -> None:
        """
        Wait until a process is listening on the given TCP port and IP address
        (default `localhost`).
        """

        def port_is_open(_last_try: bool) -> bool:
            status, _ = self.execute(f"nc -z {addr} {port}")
            return status == 0

        with self.nested(f"waiting for TCP port {port} on {addr}"):
            retry(port_is_open, timeout)

    def wait_for_open_unix_socket(
        self, addr: str, is_datagram: bool = False, timeout: int = 900
    ) -> None:
        """
        Wait until a process is listening on the given UNIX-domain socket
        (default to a UNIX-domain stream socket).
        """

        nc_flags = [
            "-z",
            "-uU" if is_datagram else "-U",
        ]

        def socket_is_open(_last_try: bool) -> bool:
            status, _ = self.execute(f"nc {' '.join(nc_flags)} {addr}")
            return status == 0

        with self.nested(
            f"waiting for UNIX-domain {'datagram' if is_datagram else 'stream'} on '{addr}'"
        ):
            retry(socket_is_open, timeout)

    def wait_for_closed_port(
        self, port: int, addr: str = "localhost", timeout: int = 900
    ) -> None:
        """
        Wait until nobody is listening on the given TCP port and IP address
        (default `localhost`).
        """

        def port_is_closed(_last_try: bool) -> bool:
            status, _ = self.execute(f"nc -z {addr} {port}")
            return status != 0

        with self.nested(f"waiting for TCP port {port} on {addr} to be closed"):
            retry(port_is_closed, timeout)

    def start_job(self, jobname: str, user: str | None = None) -> tuple[int, str]:
        return self.systemctl(f"start {jobname}", user)

    def stop_job(self, jobname: str, user: str | None = None) -> tuple[int, str]:
        return self.systemctl(f"stop {jobname}", user)

    def wait_for_job(self, jobname: str) -> None:
        self.wait_for_unit(jobname)

    def connect(self) -> None:
        def shell_ready(timeout_secs: int) -> bool:
            """We sent some data from the backdoor service running on the guest
            to indicate that the backdoor shell is ready.
            As soon as we read some data from the socket here, we assume that
            our root shell is operational.
            """
            (ready, _, _) = select.select([self.shell], [], [], timeout_secs)
            return bool(ready)

        if self.connected:
            return

        with self.nested("waiting for the VM to finish booting"):
            self.start()

            assert self.shell

            tic = time.time()
            # TODO: do we want to bail after a set number of attempts?
            while not shell_ready(timeout_secs=30):
                self.log("Guest root shell did not produce any data yet...")
                self.log(
                    "  To debug, enter the VM and run 'systemctl status backdoor.service'."
                )

            while True:
                chunk = self.shell.recv(1024)
                if len(chunk) == 0:
                    raise RuntimeError("Shell disconnected")
                self.log(f"Guest shell says: {chunk!r}")
                # NOTE: for this to work, nothing must be printed after this line!
                if b"Spawning backdoor root shell..." in chunk:
                    break

            toc = time.time()

            self.log("connected to guest root shell")
            self.log(f"(connecting took {toc - tic:.2f} seconds)")
            self.connected = True

    @contextmanager
    def _managed_screenshot(self) -> Generator[Path]:
        """
        Take a screenshot and yield the screenshot filepath.
        The file will be deleted when leaving the generator.
        """
        with tempfile.TemporaryDirectory() as tmpdir:
            screenshot_path: Path = Path(tmpdir) / "ppm"
            self.send_monitor_command(f"screendump {screenshot_path}")
            yield screenshot_path

    def screenshot(self, filename: str) -> None:
        """
        Take a picture of the display of the virtual machine, in PNG format.
        The screenshot will be available in the derivation output.
        """
        if "." not in filename:
            filename += ".png"
        if "/" not in filename:
            filename = os.path.join(self.out_dir, filename)

        with self.nested(
            f"making screenshot {filename}",
            {"image": os.path.basename(filename)},
        ):
            with self._managed_screenshot() as screenshot_path:
                ret = subprocess.run(
                    f"pnmtopng '{screenshot_path}' > '{filename}'", shell=True
                )
                if ret.returncode != 0:
                    raise MachineError(
                        f"Cannot convert screenshot (pnmtopng returned code {ret.returncode})"
                    )

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
        """
        Copies a file from host to machine, e.g.,
        `copy_from_host("myfile", "/etc/my/important/file")`.

        The first argument is the file on the host. Note that the "host" refers
        to the environment in which the test driver runs, which is typically the
        Nix build sandbox.

        The second argument is the location of the file on the machine that will
        be written to.

        The file is copied via the `shared_dir` directory which is shared among
        all the VMs (using a temporary directory).
        The access rights bits will mimic the ones from the host file and
        user:group will be root:root.
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

    def get_screen_text_variants(self) -> list[str]:
        """
        Return a list of different interpretations of what is currently
        visible on the machine's screen using optical character
        recognition. The number and order of the interpretations is not
        specified and is subject to change, but if no exception is raised at
        least one will be returned.

        ::: {.note}
        This requires [`enableOCR`](#test-opt-enableOCR) to be set to `true`.
        :::
        """
        with self._managed_screenshot() as screenshot_path:
            return perform_ocr_variants_on_screenshot(screenshot_path)

    def get_screen_text(self) -> str:
        """
        Return a textual representation of what is currently visible on the
        machine's screen using optical character recognition.

        ::: {.note}
        This requires [`enableOCR`](#test-opt-enableOCR) to be set to `true`.
        :::
        """
        with self._managed_screenshot() as screenshot_path:
            return perform_ocr_on_screenshot(screenshot_path)

    def wait_for_text(self, regex: str, timeout: int = 900) -> None:
        """
        Wait until the supplied regular expressions matches the textual
        contents of the screen by using optical character recognition (see
        `get_screen_text` and `get_screen_text_variants`).

        ::: {.note}
        This requires [`enableOCR`](#test-opt-enableOCR) to be set to `true`.
        :::
        """

        def screen_matches(last_try: bool) -> bool:
            variants = self.get_screen_text_variants()
            for text in variants:
                if re.search(regex, text) is not None:
                    return True

            if last_try:
                self.log(f"Last OCR attempt failed. Text was: {variants}")

            return False

        with self.nested(f"waiting for {regex} to appear on screen"):
            retry(screen_matches, timeout)

    def wait_for_console_text(self, regex: str, timeout: int | None = None) -> None:
        """
        Wait until the supplied regular expressions match a line of the
        serial console output.
        This method is useful when OCR is not possible or inaccurate.

        When this method returns, the console output that includes the match has already become part of get_console_log().
        """
        # Buffer the console output, this is needed
        # to match multiline regexes.
        console = io.StringIO()

        def console_matches(_last_try: bool) -> bool:
            nonlocal console
            try:
                # This will return as soon as possible and
                # sleep 1 second.
                console.write(self.last_lines.get(block=False))
            except queue.Empty:
                pass
            console.seek(0)
            matches = re.search(regex, console.read())
            return matches is not None

        with self.nested(f"waiting for {regex} to appear on console"):
            if timeout is not None:
                retry(console_matches, timeout)
            else:
                while not console_matches(False):
                    pass

    def get_console_log(self) -> str:
        """
        Get the full console output from the machine since boot.
        Returns all serial console output as a single string.
        """
        return "\n".join(self.full_console_log)

    def send_key(
        self, key: str, delay: float | None = 0.01, log: bool | None = True
    ) -> None:
        """
        Simulate pressing keys on the virtual keyboard, e.g.,
        `send_key("ctrl-alt-delete")`.

        Please also refer to the QEMU documentation for more information on the
        input syntax: https://en.wikibooks.org/wiki/QEMU/Monitor#sendkey_keys
        """
        key = CHAR_TO_KEY.get(key, key)
        context = self.nested(f"sending key {repr(key)}") if log else nullcontext()
        with context:
            self.send_monitor_command(f"sendkey {key}")
            if delay is not None:
                time.sleep(delay)

    def send_console(self, chars: str) -> None:
        r"""
        Send keys to the kernel console. This allows interaction with the systemd
        emergency mode, for example. Takes a string that is sent, e.g.,
        `send_console("\n\nsystemctl default\n")`.
        """
        assert self.process
        assert self.process.stdin
        self.process.stdin.write(chars.encode())
        self.process.stdin.flush()

    def start(self, allow_reboot: bool = False) -> None:
        """
        Start the virtual machine. This method is asynchronous --- it does
        not wait for the machine to finish booting.
        """
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
            self.qmp_path,
            self.shell_path,
            allow_reboot,
        )
        self.monitor, _ = monitor_socket.accept()
        self.shell, _ = shell_socket.accept()
        self.qmp_client = QMPSession.from_path(self.qmp_path)

        # Store last serial console lines for use
        # of wait_for_console_text
        self.last_lines: Queue = Queue()
        # Re-initialize (if this is not the first start)
        self.full_console_log: list[str] = []

        def process_serial_output() -> None:
            assert self.process
            assert self.process.stdout
            for _line in self.process.stdout:
                # Ignore undecodable bytes that may occur in boot menus
                line = _line.decode(errors="ignore").replace("\r", "").rstrip()
                self.full_console_log.append(line)
                # Put on queue after adding to full_console_log to guarantee ordering
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
        self.logger.log(f"deleting VM state directory {self.state_dir}")
        self.logger.log("if you want to keep the VM state, pass --keep-vm-state")

    def shutdown(self) -> None:
        """
        Shut down the machine, waiting for the VM to exit.
        """
        if not self.booted:
            return

        assert self.shell
        self.shell.send(b"poweroff\n")
        self.wait_for_shutdown()

    def crash(self) -> None:
        """
        Simulate a sudden power failure, by telling the VM to exit immediately.
        """
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
        self.send_key("ctrl-alt-delete")
        self.connected = False

    def wait_for_x(self, timeout: int = 900) -> None:
        """
        Wait until it is possible to connect to the X server.
        """

        def check_x(_last_try: bool) -> bool:
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
            retry(check_x, timeout)

    def get_window_names(self) -> list[str]:
        return self.succeed(
            r"xwininfo -root -tree | sed 's/.*0x[0-9a-f]* \"\([^\"]*\)\".*/\1/; t; d'"
        ).splitlines()

    def wait_for_window(self, regexp: str, timeout: int = 900) -> None:
        """
        Wait until an X11 window has appeared whose name matches the given
        regular expression, e.g., `wait_for_window("Terminal")`.
        """
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
            retry(window_is_visible, timeout)

    def sleep(self, secs: int) -> None:
        # We want to sleep in *guest* time, not *host* time.
        self.succeed(f"sleep {secs}")

    def forward_port(self, host_port: int = 8080, guest_port: int = 80) -> None:
        """
        Forward a TCP port on the host to a TCP port on the guest.
        Useful during interactive testing.
        """
        self.send_monitor_command(f"hostfwd_add tcp::{host_port}-:{guest_port}")

    def block(self) -> None:
        """
        Simulate unplugging the Ethernet cable that connects the machine to
        the other machines.
        This happens by shutting down eth1 (the multicast interface used to talk
        to the other VMs). eth0 is kept online to still enable the test driver
        to communicate with the machine.
        """
        self.send_monitor_command("set_link virtio-net-pci.1 off")

    def unblock(self) -> None:
        """
        Undo the effect of `block`.
        """
        self.send_monitor_command("set_link virtio-net-pci.1 on")

    def release(self) -> None:
        if self.pid is None:
            return
        self.logger.info(f"kill machine (pid {self.pid})")
        assert self.process
        assert self.shell
        assert self.monitor
        assert self.serial_thread

        self.process.terminate()
        self.shell.close()
        self.monitor.close()
        self.serial_thread.join()

        if self.qmp_client:
            self.qmp_client.close()

    def run_callbacks(self) -> None:
        for callback in self.callbacks:
            callback()

    def switch_root(self) -> None:
        """
        Transition from stage 1 to stage 2. This requires the
        machine to be configured with `testing.initrdBackdoor = true`
        and `boot.initrd.systemd.enable = true`.
        """
        self.wait_for_unit("initrd.target")
        self.execute(
            "systemctl isolate --no-block initrd-switch-root.target 2>/dev/null >/dev/null",
            check_return=False,
            check_output=False,
        )
        self.connected = False
        self.connect()
