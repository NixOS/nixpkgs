import subprocess
import tempfile
from collections.abc import Iterator
from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path


@dataclass
class VHostVsock:
    name: str
    guest: Path
    host: Path

    @property
    def qemu_args(self) -> str:
        return (
            f" -chardev socket,id=vsock_ssh,reconnect=0,path={self.guest} "
            f"-device vhost-user-vsock-pci,chardev=vsock_ssh "
        )

    def gen_vhost_vsock_args(self, cid: int) -> list[str]:
        return ["--vm", f"guest-cid={cid},socket={self.guest},uds-path={self.host}"]


class VHostVsockNop(VHostVsock):
    def __init__(self, name: str) -> None:
        super().__init__(name, Path("/dev/null"), Path("/dev/null"))

    @property
    def qemu_args(self) -> str:
        return ""

    def gen_vhost_vsock_args(self, cid: int) -> list[str]:
        raise NotImplementedError()


@contextmanager
def vhost_device_vsock(
    enable_ssh_backdoor: bool, start_scripts: Iterator[str]
) -> Iterator[dict[str, VHostVsock]]:
    if not enable_ssh_backdoor:
        yield {name: VHostVsockNop(name) for name in start_scripts}
    else:
        with tempfile.TemporaryDirectory() as temp_dir:
            socket_dir = Path(temp_dir)
            sockets = {
                machine: VHostVsock(
                    machine,
                    socket_dir / f"{machine}_guest.socket",
                    socket_dir / f"{machine}_host.socket",
                )
                for machine in start_scripts
            }

            if not sockets:
                yield {}
            else:
                proc = subprocess.Popen(
                    (
                        "vhost-device-vsock",
                        *(
                            arg
                            for guest_cid, sock in enumerate(sockets.values(), start=3)
                            for arg in sock.gen_vhost_vsock_args(guest_cid)
                        ),
                    )
                )

                try:
                    yield sockets
                finally:
                    proc.kill()
