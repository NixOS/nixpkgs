import argparse
import asyncio
import logging
import os
import signal
import subprocess
from contextlib import AsyncExitStack, asynccontextmanager
from dataclasses import dataclass
from pathlib import Path
from sys import exit, platform

logger = logging.getLogger(__name__)


def fatal_error(msg: str):
    logger.error(msg)
    exit(1)


async def create_empty_disk_image(target: Path, size: int):
    loop = asyncio.get_running_loop()
    if not await loop.run_in_executor(None, lambda: target.exists()):
        proc = await asyncio.create_subprocess_exec(
            "qemu-img",
            "create",
            "-f",
            "qcow2",
            target,
            f"{size}M",
        )
        await proc.wait()


@asynccontextmanager
async def virtiofsd(virtiofs_dir: Path, tag: str, source: Path, cache: str, flag: str):
    socket_path = virtiofs_dir / tag
    proc = await asyncio.create_subprocess_exec(
        "virtiofsd",
        f"--socket-path={socket_path}",
        f"--shared-dir={source.resolve()}",
        f"--{flag}",
        "--sandbox=none",
        "--seccomp=none",
        f"--cache={cache}",
        "--no-announce-submounts",
        "--translate-uid=host:65534:0:1",
        "--translate-gid=host:65534:0:1",
    )

    try:
        loop = asyncio.get_running_loop()
        while not await loop.run_in_executor(None, lambda: socket_path.exists()):
            if proc.returncode is not None:
                fatal_error(f"virtiofsd process for '{tag}' failed to start. Aborting.")
            await asyncio.sleep(1)

        yield
    finally:
        try:
            proc.terminate()
            async with asyncio.timeout(2):
                await proc.communicate()
        except ProcessLookupError:
            pass
        except TimeoutError:
            logger.warning(
                f"virtiofsd process for '{tag}' still running after SIGTERM. Killing."
            )
            proc.kill()
            await proc.communicate()


async def assert_accelerator_available():
    if platform == "linux":
        devkvm = Path("/dev/kvm")
        if not devkvm.exists():
            logger.error("forceAccel is enabled but /dev/kvm does not exist.")
            fatal_error(
                "Hardware-accelerated virtualisation (KVM) is not available on this system."
            )

        if not (os.access(devkvm, os.W_OK) and os.access(devkvm, os.R_OK)):
            logger.error(
                "forceAccel is enabled but /dev/kvm is not accessible (permission denied)."
            )
            fatal_error(
                "Check that the nix build user is in the 'kvm' group or that /dev/kvm has the correct permissions."
            )
    elif platform == "darwin":
        proc = await asyncio.create_subprocess_exec(
            "sysctl",
            "-n",
            "kern.hv_support",
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
        )
        exitcode = await proc.wait()
        if exitcode == 0 and await proc.stdout.read().strip() == "1":
            return
        fatal_error(
            "forceAccel is enabled but Hypervisor.framework is not available on this system."
        )
    else:
        fatal_error(
            "forceAccel is enabled but no known accelerator is available for this platform."
        )


@dataclass
class Settings:
    virtiofsds: list[tuple[str, Path, str, str]]
    qemu_args: list[str]
    force_accel: bool
    empty_disk_images: list[int]
    virtiofs_dir: Path


def extract_arguments() -> Settings:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--virtiofs-paths",
        nargs="+",
        default=[],
        help="Paths to be exposed with virtiofsd in the format 'tag:source:cache:mode'",
    )
    parser.add_argument(
        "--force-accel",
        action="store_true",
        help="Whether it's intended to run with an accelerator.",
    )
    parser.add_argument(
        "--empty-disk-images",
        nargs="+",
        type=int,
        default=[],
        help="Empty disk images to create. Each value is the size in MiB.",
    )
    parser.add_argument(
        "--virtiofs_dir",
        type=Path,
        default=Path("virtiofsd"),
        help="State dir where socket of each virtiofsd instance is saved. Assumed to be inside the TMPDIR and thus not cleaned up on its own.",
    )

    args, qemu_args = parser.parse_known_args()
    if not qemu_args:
        logger.warning("No command to run specified, exiting")
        exit(0)

    if qemu_args[0] != "--":
        fatal_error(
            "Usage error: expected command to run separated with '--' from the args passed to this program!"
        )
    qemu_args.pop(0)
    if not qemu_args:
        logger.warning("No command to run specified, exiting")
        exit(0)

    defs = []
    for defin in args.virtiofs_paths:
        inner = defin.split(":")
        if len(inner) != 4:
            fatal_error(
                f"--virtiofs-paths definition '{defin}' doesn't have four params separated by ':'!"
            )
        defs.append((inner[0], Path(inner[1]), inner[2], inner[3]))

    return Settings(
        virtiofsds=defs,
        qemu_args=qemu_args,
        force_accel=args.force_accel,
        empty_disk_images=args.empty_disk_images,
        virtiofs_dir=args.virtiofs_dir,
    )


async def amain():
    logging.basicConfig(format="%(levelname)s: %(funcName)s: %(message)s")
    settings = extract_arguments()

    if settings.force_accel:
        await assert_accelerator_available()

    if settings.virtiofsds and platform != "linux":
        fatal_error(
            "virtiofsd is only supported on Linux! Use 9pfs with this wrapper on other platforms!"
        )

    settings.virtiofs_dir.mkdir(exist_ok=True, parents=True)

    await asyncio.gather(
        *(
            create_empty_disk_image(Path(f"empty{idx}.qcow2"), size)
            for idx, size in enumerate(settings.empty_disk_images)
        )
    )

    async with AsyncExitStack() as virtiofsds:
        await asyncio.gather(
            *(
                virtiofsds.enter_async_context(virtiofsd(settings.virtiofs_dir, *defin))
                for defin in settings.virtiofsds
            )
        )

        proc = await asyncio.create_subprocess_exec(
            *settings.qemu_args, close_fds=False
        )
        loop = asyncio.get_running_loop()
        loop.add_signal_handler(signal.SIGTERM, lambda: proc.terminate())
        loop.add_signal_handler(signal.SIGINT, lambda: proc.terminate())
        await proc.communicate()

    return proc.returncode


def main():
    return asyncio.run(amain())


if __name__ == "__main__":
    exit(main())
