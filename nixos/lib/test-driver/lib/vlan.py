"""The VLan knows how to manage the lifecycle of
virtual distributed ethernet (VDE) switch for guest machines
"""
from typing import Optional, Callable
import os
import io
import pty
import subprocess

from pathlib import Path


class VLan:
    """A handle to the vlan with this number, that also knows how to manage
    it's lifecycle.

    Currently, a management API is not (yet) implemented.
    TODO: implement `vdeterm` + VDE controle plane
    """

    nr: int
    socket_dir: Path
    log: Callable

    process: Optional[subprocess.Popen]
    pid: Optional[int]
    fd: Optional[io.TextIOBase]

    def __init__(self, nr: int, tmp_dir: Path, log: Callable):
        self.nr = nr
        self.socket_dir = tmp_dir / f"vde{self.nr}.ctl"
        # setattr workaround for mypy type checking, see: https://git.io/JGyNT
        setattr(
            self, "log", lambda msg: log(f"[VLAN NR {self.nr}] {msg}", {"vde": self.nr})
        )

        # TODO: don't side-effect environment here
        os.environ[f"QEMU_VDE_SOCKET_{self.nr}"] = str(self.socket_dir)

    def start(self) -> None:

        self.log("start")
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
            raise Exception("cannot start vde_switch")

        self.log(f"running (pid {self.pid})")

    def release(self) -> None:
        if self.pid is None:
            return
        self.log(f"kill me (pid {self.pid})")
        if self.fd is not None:
            self.fd.close()
        if self.process is not None:
            self.process.terminate()

