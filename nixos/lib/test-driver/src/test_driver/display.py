import os
import platform
import signal
import subprocess
import threading
import time
from collections.abc import Callable, Iterable
from dataclasses import dataclass
from typing import Protocol

from test_driver.config import (
    DisplayProtocol,
    DisplayViewerConfiguration,
    VncDisplayViewerConfiguration,
)


def graphical_display_available() -> bool:
    if platform.system() == "Darwin":
        # We have no DISPLAY variables on macOS and seemingly no better way
        # to find out.
        return "TERM_PROGRAM" in os.environ

    return any(name in os.environ for name in ("DISPLAY", "WAYLAND_DISPLAY"))


@dataclass(frozen=True)
class DisplayEndpoint:
    protocol: DisplayProtocol
    uri: str


class DisplayViewer(Protocol):
    def start(self) -> None: ...

    def is_running(self) -> bool: ...

    @property
    def returncode(self) -> int | None: ...

    def stop(self) -> None: ...


class DisplayExporter(Protocol):
    description: str
    protocol: DisplayProtocol

    def open(self, stop_event: threading.Event) -> DisplayEndpoint | None: ...

    def stop(self) -> None: ...


def terminate_process_groups(
    processes: Iterable[subprocess.Popen[bytes]],
    description: str,
    log: Callable[[str], None],
) -> None:
    running = [process for process in processes if process.poll() is None]
    for process in running:
        try:
            os.killpg(process.pid, signal.SIGTERM)
        except ProcessLookupError:
            pass

    deadline = time.monotonic() + 5
    for process in running:
        try:
            process.wait(timeout=max(0, deadline - time.monotonic()))
        except subprocess.TimeoutExpired:
            log(f"{description} did not exit after SIGTERM; sending SIGKILL")
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass

    for process in running:
        process.wait()


class VncDisplayViewer:
    def __init__(
        self,
        configuration: VncDisplayViewerConfiguration,
        endpoint: DisplayEndpoint,
        log: Callable[[str], None],
    ) -> None:
        if endpoint.protocol != "vnc":
            raise ValueError(
                f"VNC viewer cannot open a {endpoint.protocol} display endpoint"
            )

        self.configuration = configuration
        self.endpoint = endpoint
        self.log = log
        self.process: subprocess.Popen[bytes] | None = None
        self.cleanup_lock = threading.Lock()

    def start(self) -> None:
        self.process = subprocess.Popen(
            [str(self.configuration.executable), self.endpoint.uri],
            start_new_session=True,
        )
        self.log(f"VNC viewer running (pid {self.process.pid})")

    def is_running(self) -> bool:
        return self.process is not None and self.process.poll() is None

    @property
    def returncode(self) -> int | None:
        if self.process is None:
            return None
        return self.process.poll()

    def stop(self) -> None:
        with self.cleanup_lock:
            process = self.process
            if process is None:
                return
            terminate_process_groups([process], "VNC viewer", self.log)


def create_display_viewer(
    configuration: DisplayViewerConfiguration,
    endpoint: DisplayEndpoint,
    log: Callable[[str], None],
) -> DisplayViewer:
    if configuration.kind == "vnc":
        return VncDisplayViewer(configuration, endpoint, log)

    raise ValueError(f"unsupported display viewer kind {configuration.kind}")


class DisplaySession:
    def __init__(
        self,
        *,
        exporter: DisplayExporter,
        viewer_configuration: DisplayViewerConfiguration,
        machine_running: Callable[[], bool],
        log: Callable[[str], None],
    ) -> None:
        self.exporter = exporter
        self.viewer_configuration = viewer_configuration
        self.machine_running = machine_running
        self.log = log

        self.stop_event = threading.Event()
        self.thread: threading.Thread | None = None
        self.viewer: DisplayViewer | None = None
        self.lock = threading.Lock()
        self.cleanup_lock = threading.Lock()

    def start(self) -> None:
        self.thread = threading.Thread(target=self._run, daemon=True)
        self.thread.start()

    def stop(self) -> None:
        with self.cleanup_lock:
            self.stop_event.set()
            with self.lock:
                viewer = self.viewer
            if viewer is not None:
                viewer.stop()
            self.exporter.stop()

    def join(self) -> None:
        thread = self.thread
        if thread is not None:
            thread.join(timeout=5)
            if thread.is_alive():
                self.log("display session did not stop within 5 seconds")
                return
            self.thread = None

    def _run(self) -> None:
        try:
            endpoint = self.exporter.open(self.stop_event)
            if endpoint is None:
                return

            viewer = create_display_viewer(
                self.viewer_configuration, endpoint, self.log
            )
            with self.lock:
                if self.stop_event.is_set():
                    return
                self.viewer = viewer
                viewer.start()

            while (
                not self.stop_event.is_set()
                and self.machine_running()
                and viewer.is_running()
            ):
                self.stop_event.wait(0.5)

            if not self.stop_event.is_set() and not viewer.is_running():
                self.log(
                    f"{self.viewer_configuration.kind.upper()} viewer exited "
                    f"(status {viewer.returncode})"
                )
        except Exception as error:
            if not self.stop_event.is_set():
                self.log(
                    f"failed to open the viewer for {self.exporter.description}: {error}"
                )
        finally:
            self.stop()
