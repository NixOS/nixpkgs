import datetime as dt
import fcntl
import io
import os
import select
import subprocess
import typing
from pathlib import Path

from test_driver.logger import AbstractLogger


def readline_with_timeout(
    readable: typing.IO[str], timeout: dt.timedelta
) -> typing.Generator[str]:
    """
    Read a line from `readable` within the given `timeout`, otherwise raises `TimeoutError`.

    Note: while the generator is running, `readable` will be in nonblocking mode.
    """
    fd = readable.fileno()
    og_flags = fcntl.fcntl(fd, fcntl.F_GETFL)
    fcntl.fcntl(fd, fcntl.F_SETFL, og_flags | os.O_NONBLOCK)

    try:
        while True:
            ready, _, _ = select.select([readable], [], [], timeout.total_seconds())
            if len(ready) == 0:
                raise TimeoutError()

            # Under the hood, `readline` may read more than one line from the file descriptor,
            # so we cannot just return to the `select`, as it may block, despite there being more
            # lines buffered. So, read all the lines before returning to the select. This only
            # works if the file descriptor is in non-blocking mode!
            while line := readable.readline():
                yield line
    finally:
        fcntl.fcntl(fd, fcntl.F_SETFL, og_flags)


class VLan:
    """This class handles a VLAN that the run-vm scripts identify via its
    number handles. The network's lifetime equals the object's lifetime.
    """

    nr: int
    socket_dir: Path

    process: subprocess.Popen
    pid: int
    fd: io.TextIOBase

    logger: AbstractLogger

    def __repr__(self) -> str:
        return f"<Vlan Nr. {self.nr}>"

    def __init__(self, nr: int, tmp_dir: Path, logger: AbstractLogger):
        self.nr = nr
        self.socket_dir = tmp_dir / f"vde{self.nr}.ctl"
        self.logger = logger

        # TODO: don't side-effect environment here
        os.environ[f"QEMU_VDE_SOCKET_{self.nr}"] = str(self.socket_dir)

        self.logger.info("start vlan")

        self.process = subprocess.Popen(
            [
                "vde_switch",
                "--sock",
                self.socket_dir,
                "--dirmode",
                "0700",
                # The --hub is required for the scenario determined by
                # nixos/tests/networkd-and-scripted.nix vlan-ping.
                # VLAN Tagged traffic (802.1Q) seems to be blocked if a vde_switch is
                # used without the hub mode (flood packets to all ports).
                "--hub",
            ],
            bufsize=1,  # Line buffered.
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=None,  # Do not swallow stderr.
            text=True,
        )
        self.pid = self.process.pid

        assert self.process.stdin is not None
        self.process.stdin.write("showinfo\n")

        # showinfo's output looks like this:
        #
        # ```
        # vde$ showinfo
        # 0000 DATA END WITH '.'
        # VDE switch V.2.3.3
        # (C) Virtual Square Team (coord. R. Davoli) 2005,2006,2007 - GPLv2
        #
        # pid 82406 MAC 00:ff:62:25:47:55 uptime 45
        # .
        # 1000 Success
        # ```
        #
        # We read past all the output until we get to the `1000 Success`.
        # This serves 2 purposes:
        #   1. It's a nice sanity check that `vde_switch` is actually working.
        #   2. By the time we're done, `vde_switch` will have created the
        #      `ctl` socket in `socket_dir`, so we don't have to wait for it to exist.
        assert self.process.stdout is not None
        for line in readline_with_timeout(
            self.process.stdout, timeout=dt.timedelta(seconds=5)
        ):
            if "1000 Success" in line:
                break

        assert (self.socket_dir / "ctl").exists(), "cannot start vde_switch"

        self.logger.info(f"running vlan (pid {self.pid}; ctl {self.socket_dir})")

    def stop(self) -> None:
        self.logger.info(f"kill vlan (pid {self.pid})")
        assert self.process.stdin is not None
        self.process.stdin.close()
        self.process.terminate()
