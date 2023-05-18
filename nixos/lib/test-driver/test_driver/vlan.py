from pathlib import Path
import io
import os
import pty
import subprocess

from test_driver.logger import rootlog


class VLan:
    """This class handles a VLAN that the run-vm scripts identify via its
    number handles. The network's lifetime equals the object's lifetime.
    """

    nr: int
    socket_dir: Path

    process: subprocess.Popen
    pid: int
    fd: io.TextIOBase

    def __repr__(self) -> str:
        return f"<Vlan Nr. {self.nr}>"

    def __init__(self, nr: int, tmp_dir: Path):
        self.nr = nr
        self.socket_dir = tmp_dir / f"vde{self.nr}.ctl"

        # TODO: don't side-effect environment here
        os.environ[f"QEMU_VDE_SOCKET_{self.nr}"] = str(self.socket_dir)

        rootlog.info("start vlan")
        pty_master, pty_slave = pty.openpty()

        # The --hub is required for the scenario determined by
        # nixos/tests/networking.nix vlan-ping.
        # VLAN Tagged traffic (802.1Q) seams to be blocked if a vde_switch is
        # used without the hub mode (flood packets to all ports).
        self.process = subprocess.Popen(
            ["vde_switch", "-s", self.socket_dir, "--dirmode", "0700", "--hub"],
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
            rootlog.error("cannot start vde_switch")

        rootlog.info(f"running vlan (pid {self.pid}; ctl {self.socket_dir})")

    def __del__(self) -> None:
        rootlog.info(f"kill vlan (pid {self.pid})")
        self.fd.close()
        self.process.terminate()
