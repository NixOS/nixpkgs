import datetime as dt
import shutil
import socket
import subprocess
import threading
import time
from collections.abc import Callable
from contextlib import _GeneratorContextManager
from pathlib import Path

from test_driver.errors import MachineError, RequestedAssertionFailed
from test_driver.logger import AbstractLogger


class NspawnProcess:
    """Commands and readiness for one container instance, without starting it."""

    def __init__(
        self,
        process: subprocess.Popen,
        notify_socket: socket.socket,
        name: str,
        shared_dir: Path,
        logger: AbstractLogger,
    ) -> None:
        self.process = process
        self.notify_socket = notify_socket
        self.name = name
        self.shared_dir = shared_dir
        self.logger = logger
        # State maintained by the notify-socket drainer thread (see
        # `_drain_notify_socket`). Guarded by `_notify_lock`.
        self._notify_lock = threading.Lock()
        self._notify_ready = False
        self._notify_leader_pid: int | None = None

        # Keep the notify socket drained for the container's whole lifetime, so
        # PID 1 never blocks re-sending `READY=1` on `daemon-reexec`.
        self._notify_thread = threading.Thread(
            target=self._drain_notify_socket, daemon=True
        )
        self._notify_thread.start()

    def is_running(self) -> bool:
        return self.process.poll() is None

    def log(self, message: str) -> None:
        self.logger.log(message, {"machine": self.name})

    def nested(self, message: str) -> _GeneratorContextManager:
        return self.logger.nested(message, {"machine": self.name})

    def close(self) -> None:
        self.notify_socket.close()
        self._notify_thread.join()

    def _drain_notify_socket(self) -> None:
        """Continuously drain the container's `sd_notify` socket (NOTIFY_SOCKET)
        for the whole lifetime of the container, recording readiness and the
        leader PID as they arrive.

        Draining must not stop after boot: the container's PID 1 re-sends
        `READY=1` on every `systemctl daemon-reexec` (the same Manager.Reexecute
        that switch-to-configuration issues on a systemd change). If nothing
        reads the socket, its receive buffer fills and PID 1 blocks in
        `sendmsg()` to NOTIFY_SOCKET while re-executing -- it never finishes
        re-initializing, and every later `systemctl` call inside the container
        hangs or fails with `Transport endpoint is not connected`.
        """
        sock = self.notify_socket
        # Keep draining for this container's lifetime. Any datagrams still
        # queued after it exits are stale, so drop them.
        while self.is_running():
            try:
                # Block (with a timeout so we notice the container exiting)
                # rather than busy-poll; we just need to keep the buffer empty.
                sock.settimeout(0.5)
                data, _ = sock.recvfrom(4096)
            except (TimeoutError, BlockingIOError):
                continue
            except OSError:
                break

            ready = False
            leader_pid = None
            for line in data.decode(errors="replace").splitlines():
                if line == "READY=1":
                    ready = True
                if line.startswith("X_NSPAWN_LEADER_PID="):
                    leader_pid = int(line.split("=")[1])
            if ready or leader_pid is not None:
                with self._notify_lock:
                    if ready:
                        self._notify_ready = True
                    if leader_pid is not None:
                        self._notify_leader_pid = leader_pid

    def wait_for_boot(self, stop_event: threading.Event | None = None) -> int:
        """Block until startup is complete and return the PID of the container's systemd process.

        Readiness and the leader PID are reported over NOTIFY_SOCKET, which is
        drained by `_drain_notify_socket` (started in `__init__`); we just wait
        for that thread to record both.
        """
        start_time = time.monotonic()
        last_warning = start_time
        delay = 0.01
        max_delay = 0.5

        # Poll the socket until we have the container leader PID
        while True:
            if not self.is_running():
                raise MachineError("systemd-nspawn process exited unexpectedly")

            if stop_event is not None and stop_event.is_set():
                raise InterruptedError("container readiness wait cancelled")

            with self._notify_lock:
                is_ready = self._notify_ready
                container_pid = self._notify_leader_pid
            if is_ready and container_pid is not None:
                return container_pid

            # Print periodic warnings every 10s so the user knows we aren't deadlocked
            now = time.monotonic()
            if now - last_warning > 10.0:
                self.log(
                    f"still waiting for container '{self.name}' to reach ready state..."
                )
                last_warning = now

            if stop_event is None:
                time.sleep(delay)
            else:
                stop_event.wait(delay)
            delay = min(delay * 2, max_delay)

    def wait_for_x(
        self,
        timeout: dt.timedelta = dt.timedelta(minutes=15),
        *,
        stop_event: threading.Event | None = None,
        before_probe: Callable[[], None] | None = None,
    ) -> None:
        """Wait until it is possible to connect to the X server."""
        with self.nested("waiting for the X11 server"):
            deadline = time.monotonic() + timeout.total_seconds()

            while True:
                if before_probe is not None:
                    before_probe()
                self.wait_for_boot(stop_event)

                try:
                    # Bound each probe so a stuck X11 connection cannot block cleanup.
                    status, _ = self.execute(
                        "xwininfo -root >/dev/null 2>&1",
                        timeout=dt.timedelta(seconds=5),
                    )
                except subprocess.TimeoutExpired:
                    self.log("X11 readiness check timed out")
                else:
                    if status == 0:
                        return

                if time.monotonic() >= deadline:
                    raise RequestedAssertionFailed(
                        "timed out waiting for the X11 server"
                    )

                if stop_event is None:
                    time.sleep(1)
                else:
                    stop_event.wait(1)

    def execute(
        self, command: str, timeout: dt.timedelta | None = dt.timedelta(minutes=15)
    ) -> tuple[int, str]:
        container_pid = self.wait_for_boot()
        nsenter = shutil.which("nsenter")
        assert nsenter is not None

        # Sourcing /etc/profile on every call of `execute` ensures a correct shell
        # environment (correct PATH, etc.). This is slower than the QEMU version.
        #
        # NOTE If the test calls switch-to-configuration (with a differently configured specialization)
        # this will use the /etc/profile of the new specialisation while `QemuMachine` nodes
        # will continue to use the original /etc/profile.
        command = (
            "set -eo pipefail; "
            "export USER=root HOME=/root DISPLAY=:0.0; "
            f"source /etc/profile; set -u; {command}"
        )

        cp = subprocess.run(
            [
                nsenter,
                "--target",
                str(container_pid),
                "--mount",
                "--uts",
                "--ipc",
                "--net",
                "--pid",
                "--cgroup",
                "/bin/sh",
                "-c",
                command,
            ],
            env={},
            timeout=timeout.total_seconds() if timeout is not None else None,
            stdout=subprocess.PIPE,
            text=True,
        )
        return (cp.returncode, cp.stdout)

    def succeed(self, command: str, timeout: dt.timedelta | None = None) -> str:
        with self.nested(f"must succeed: {command}"):
            (status, output) = self.execute(command, timeout=timeout)
            if status != 0:
                self.log(f"output: {output}")
                raise RequestedAssertionFailed(
                    f"command `{command}` failed (exit code {status})"
                )
            return output
