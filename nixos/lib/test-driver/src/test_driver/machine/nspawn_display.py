import datetime as dt
import shlex
import shutil
import socket
import subprocess
import threading
import time
from collections.abc import Callable
from typing import Protocol

from test_driver.config import (
    DisplayProtocol,
    DisplayTargetConfiguration,
    NspawnDisplayExporterConfiguration,
    NspawnX11VncExporterConfiguration,
    X11DisplayTargetConfiguration,
)
from test_driver.display import (
    DisplayEndpoint,
    DisplayExporter,
    terminate_process_groups,
)


class ExecuteCommand(Protocol):
    def __call__(
        self,
        command: str,
        check_return: bool = True,
        check_output: bool = True,
        timeout: dt.timedelta | None = dt.timedelta(minutes=15),
    ) -> tuple[int, str]: ...


class NspawnX11VncExporter:
    protocol: DisplayProtocol = "vnc"

    def __init__(
        self,
        *,
        target: X11DisplayTargetConfiguration,
        configuration: NspawnX11VncExporterConfiguration,
        port: int,
        unit: str,
        execute: ExecuteCommand,
        wait_for_container_pid: Callable[[], int],
        container_running: Callable[[], bool],
        log: Callable[[str], None],
    ) -> None:
        self.target = target
        self.configuration = configuration
        self.port = port
        self.unit = unit
        self.execute = execute
        self.wait_for_container_pid = wait_for_container_pid
        self.container_running = container_running
        self.log = log
        self.description = f"X display {self.target.display}"

        self.listener: socket.socket | None = None
        self.relay_thread: threading.Thread | None = None
        self.relays: list[subprocess.Popen[bytes]] = []
        self.server_started = False
        self.lock = threading.Lock()
        self.cleanup_lock = threading.Lock()

    def _wait_for_x(self, stop_event: threading.Event) -> bool:
        command = shlex.join(
            [
                "env",
                f"XAUTHORITY={self.target.xauthority}",
                "xwininfo",
                "-display",
                self.target.display,
                "-root",
            ]
        )
        last_warning = time.monotonic()
        while not stop_event.is_set():
            if not self.container_running():
                return False
            try:
                status, _ = self.execute(
                    f"{command} >/dev/null 2>&1",
                    timeout=dt.timedelta(seconds=5),
                )
            except subprocess.TimeoutExpired:
                status = 1
            if status == 0:
                return True
            now = time.monotonic()
            if now - last_warning >= 10:
                self.log(
                    f"still waiting for X display {self.target.display} before opening the viewer..."
                )
                last_warning = now
            stop_event.wait(1)
        return False

    def _start_server(self) -> bool:
        command = shlex.join(
            [
                "systemd-run",
                "--quiet",
                "--service-type=exec",
                f"--unit={self.unit}",
                str(self.configuration.server),
                "-display",
                self.target.display,
                "-auth",
                str(self.target.xauthority),
                "-localhost",
                "-nopw",
                "-forever",
                "-shared",
                "-rfbport",
                str(self.port),
            ]
        )
        status, output = self.execute(command)
        if status != 0:
            self.log(
                f"failed to start VNC server for X display {self.target.display}: {output.strip()}"
            )
            return False
        self.server_started = True
        return True

    def _wait_for_server(self, stop_event: threading.Event) -> bool:
        command = shlex.join(
            [
                str(self.configuration.relay),
                "-u",
                "/dev/null",
                f"TCP:127.0.0.1:{self.port},connect-timeout=1",
            ]
        )
        last_warning = time.monotonic()
        while not stop_event.is_set():
            if not self.container_running():
                return False
            try:
                status, _ = self.execute(
                    f"{command} >/dev/null 2>&1",
                    timeout=dt.timedelta(seconds=2),
                )
            except subprocess.TimeoutExpired:
                status = 1
            if status == 0:
                return True
            service_failed, _ = self.execute(
                f"systemctl is-failed --quiet {self.unit}.service"
            )
            if service_failed == 0:
                self.log(
                    f"VNC server for X display {self.target.display} exited before accepting connections"
                )
                return False
            now = time.monotonic()
            if now - last_warning >= 10:
                self.log(
                    f"still waiting for the VNC server for X display {self.target.display}..."
                )
                last_warning = now
            stop_event.wait(1)
        return False

    def _relay_connections(
        self,
        nsenter: str,
        container_pid: int,
        listener: socket.socket,
        stop_event: threading.Event,
    ) -> None:
        while not stop_event.is_set() and self.container_running():
            with self.lock:
                self.relays = [relay for relay in self.relays if relay.poll() is None]
            try:
                connection, _ = listener.accept()
            except TimeoutError:
                continue
            except OSError:
                break

            with connection:
                if stop_event.is_set():
                    break
                connection_fd = connection.fileno()
                relay = subprocess.Popen(
                    [
                        nsenter,
                        "--target",
                        str(container_pid),
                        "--net",
                        str(self.configuration.relay),
                        "-",
                        f"TCP:127.0.0.1:{self.port}",
                    ],
                    stdin=connection_fd,
                    stdout=connection_fd,
                    pass_fds=[connection_fd],
                    start_new_session=True,
                )
            with self.lock:
                self.relays.append(relay)

    def open(self, stop_event: threading.Event) -> DisplayEndpoint | None:
        if stop_event.is_set():
            return None
        nsenter = shutil.which("nsenter")
        if nsenter is None:
            raise RuntimeError("nsenter is required for nspawn display forwarding")
        container_pid = self.wait_for_container_pid()
        if not self._wait_for_x(stop_event):
            return None
        if not self._start_server():
            return None
        if not self._wait_for_server(stop_event):
            return None

        # Keep the viewer in the host network namespace. In particular, an SSH
        # forwarded DISPLAY commonly points at host loopback and would stop
        # working if the viewer itself entered the container's namespace.
        # Instead, relay each viewer connection through nsenter and socat.
        listener = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        listener.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        listener.bind(("127.0.0.1", 0))
        listener.listen()
        listener.settimeout(0.5)
        with self.lock:
            if stop_event.is_set():
                listener.close()
                return None
            self.listener = listener

        self.relay_thread = threading.Thread(
            target=self._relay_connections,
            args=(nsenter, container_pid, listener, stop_event),
            daemon=True,
        )
        self.relay_thread.start()
        host_port = listener.getsockname()[1]
        return DisplayEndpoint(protocol="vnc", uri=f"vnc://127.0.0.1:{host_port}")

    def stop(self) -> None:
        with self.cleanup_lock:
            with self.lock:
                if self.listener is not None:
                    self.listener.close()
                    self.listener = None
                relays = list(self.relays)

            terminate_process_groups(relays, "VNC relay", self.log)

            relay_thread = self.relay_thread
            if relay_thread is not None:
                relay_thread.join(timeout=5)
                if relay_thread.is_alive():
                    self.log("VNC relay thread did not stop within 5 seconds")
                else:
                    self.relay_thread = None

            if self.server_started and self.container_running():
                try:
                    self.execute(
                        shlex.join(["systemctl", "stop", f"{self.unit}.service"]),
                        check_return=False,
                        timeout=dt.timedelta(seconds=5),
                    )
                except subprocess.TimeoutExpired:
                    self.log(
                        f"timed out stopping the VNC server for X display {self.target.display}"
                    )
            self.server_started = False


def create_nspawn_display_exporter(
    *,
    target: DisplayTargetConfiguration,
    configuration: NspawnDisplayExporterConfiguration,
    port: int,
    unit: str,
    execute: ExecuteCommand,
    wait_for_container_pid: Callable[[], int],
    container_running: Callable[[], bool],
    log: Callable[[str], None],
) -> DisplayExporter:
    if target.backend == "x11" and configuration.kind == "x11-vnc":
        return NspawnX11VncExporter(
            target=target,
            configuration=configuration,
            port=port,
            unit=unit,
            execute=execute,
            wait_for_container_pid=wait_for_container_pid,
            container_running=container_running,
            log=log,
        )

    raise ValueError(
        f"unsupported nspawn display export {target.backend} via {configuration.kind}"
    )
