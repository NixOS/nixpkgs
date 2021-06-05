""" The Start Command domain knows how to interact and process
machine start scripts or command such as provided by the nix qemu modules.
"""

from typing import Optional
import os
import re
import subprocess

from pathlib import Path


class StartCommand:
    """The Base Start Command knows how to append the necesary
    runtime qemu options as determined by a particular test driver
    run. Any such start command is expected to hapily receive and
    append additional qemu args.
    """

    _cmd: str

    def cmd(
        self,
        monitor_socket_path: Path,
        shell_socket_path: Path,
        allow_reboot: bool = False,  # TODO: unused, legacy?
        tty_path: Optional[Path] = None,  # TODO: currently unused
    ) -> str:
        tty_opts = ""
        if tty_path is not None:
            tty_opts += (
                f" -chardev socket,server,nowait,id=console,path={tty_path}"
                " -device virtconsole,chardev=console"
            )
        display_opts = ""
        display_available = any(x in os.environ for x in ["DISPLAY", "WAYLAND_DISPLAY"])
        if display_available:
            display_opts += " -nographic"

        # qemu options
        qemu_opts = ""
        qemu_opts += (
            ""
            if allow_reboot
            else " -no-reboot"
            " -device virtio-serial"
            " -device virtconsole,chardev=shell"
            " -serial stdio"
        )
        # TODO: qemu script already catpures this env variable, legacy?
        qemu_opts += " " + os.environ.get("QEMU_OPTS", "")

        return (
            f"{self._cmd}"
            f" -monitor unix:{monitor_socket_path}"
            f" -chardev socket,id=shell,path={shell_socket_path}"
            f"{tty_opts}{display_opts}"
        )

    @staticmethod
    def build_environment(
        state_dir: Path,
        shared_dir: Path,
    ) -> os._Environ:
        env = os.environ
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

    These nix command have the particular charactersitic that the
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
