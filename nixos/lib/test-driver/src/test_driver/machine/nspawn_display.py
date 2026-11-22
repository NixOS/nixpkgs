import datetime as dt
import shlex
import socket
import subprocess
import tempfile
import threading
from pathlib import Path
from typing import TYPE_CHECKING, Self

from pydantic import BaseModel

if TYPE_CHECKING:
    from test_driver.machine import NspawnMachine


class NspawnVncConfiguration(BaseModel):
    x11vnc: Path
    tigervnc: Path


def _container_running(machine: "NspawnMachine") -> bool:
    process = machine.process
    return process is not None and process.poll() is None


class VncServer:
    unit = "nixos-test-vnc"

    def __init__(
        self,
        machine: "NspawnMachine",
        x11vnc_executable: Path,
        socket_path: Path,
        stop_event: threading.Event,
    ) -> None:
        self.machine = machine
        self.x11vnc_executable = x11vnc_executable
        self.socket_path = socket_path
        self.stop_event = stop_event

    def _command(self) -> list[str]:
        container_socket = Path("/tmp/shared") / self.socket_path.relative_to(
            self.machine.shared_dir
        )
        return [
            str(self.x11vnc_executable),
            "-display",
            ":0",
            "-auth",
            "/root/.Xauthority",
            "-unixsock",
            str(container_socket),
            "-desktop",
            f"{self.machine.name} (nspawn)",
            # Suppress the password warning for our private Unix socket.
            "-nopw",
            # Disable IPv4 and IPv6 TCP listeners; use only the Unix socket.
            "-rfbport",
            "0",
            "-rfbportv6",
            "0",
        ]

    def __enter__(self) -> Self:
        command = shlex.join(
            [
                "systemd-run",
                "--quiet",
                "--collect",
                "--service-type=exec",
                f"--unit={self.unit}",
                *self._command(),
            ]
        )
        try:
            self.machine.succeed(command, timeout=dt.timedelta(seconds=5))
        except BaseException:
            self._stop()
            raise
        return self

    def wait_ready(self) -> bool:
        while not self.stop_event.is_set() and _container_running(self.machine):
            with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as connection:
                connection.settimeout(1)
                try:
                    connection.connect(str(self.socket_path))
                    return True
                except (FileNotFoundError, ConnectionRefusedError, TimeoutError):
                    pass

            status, _ = self.machine.execute(
                f"systemctl is-active --quiet {self.unit}.service",
                timeout=dt.timedelta(seconds=5),
            )
            if status != 0:
                raise RuntimeError("VNC server exited before accepting connections")
            self.stop_event.wait(0.5)
        return False

    def _stop(self) -> None:
        if _container_running(self.machine):
            try:
                self.machine.execute(
                    f"systemctl stop {self.unit}.service",
                    timeout=dt.timedelta(seconds=5),
                )
            except Exception as error:
                self.machine.log(f"failed to stop the VNC server: {error}")

    def __exit__(self, *_: object) -> None:
        self._stop()


class VncViewer:
    def __init__(
        self,
        machine: "NspawnMachine",
        tigervnc_executable: Path,
        socket_path: Path,
        stop_event: threading.Event,
    ) -> None:
        self.machine = machine
        self.tigervnc_executable = tigervnc_executable
        self.socket_path = socket_path
        self.stop_event = stop_event

    def __enter__(self) -> Self:
        self.process = subprocess.Popen(
            [str(self.tigervnc_executable), str(self.socket_path)],
            # Keep terminal Ctrl-C from reaching the viewer; driver cleanup stops it.
            start_new_session=True,
        )
        self.machine.log(f"VNC viewer running (pid {self.process.pid})")
        return self

    def wait(self) -> None:
        while not self.stop_event.is_set() and _container_running(self.machine):
            if self.process.poll() is not None:
                self.machine.log(
                    f"VNC viewer exited (status {self.process.returncode})"
                )
                return
            self.stop_event.wait(0.5)

    def __exit__(self, *_: object) -> None:
        self.process.terminate()
        try:
            self.process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            self.process.kill()
            self.process.wait()


class NspawnVnc:
    """Show a container's default X11 display in TigerVNC."""

    def __init__(
        self, machine: "NspawnMachine", configuration: NspawnVncConfiguration
    ) -> None:
        self.machine = machine
        self.configuration = configuration
        self.stop_event = threading.Event()
        self.thread = threading.Thread(target=self._run, daemon=True)

    def start(self) -> None:
        self.thread.start()

    def stop(self) -> None:
        self.stop_event.set()
        self.thread.join(timeout=15)
        if self.thread.is_alive():
            self.machine.log("VNC worker did not stop within 15 seconds")

    def _run(self) -> None:
        try:
            self.machine.wait_for_x()
            if self.stop_event.is_set():
                return

            with tempfile.TemporaryDirectory(dir=self.machine.shared_dir) as directory:
                host_socket = Path(directory) / "vnc.sock"
                with VncServer(
                    self.machine,
                    self.configuration.x11vnc,
                    host_socket,
                    self.stop_event,
                ) as server:
                    if not server.wait_ready() or self.stop_event.is_set():
                        return

                    with VncViewer(
                        self.machine,
                        self.configuration.tigervnc,
                        host_socket,
                        self.stop_event,
                    ) as viewer:
                        viewer.wait()
        except Exception as error:
            if not self.stop_event.is_set():
                self.machine.log(f"failed to open the VNC viewer: {error}")
