import argparse
import asyncio
import logging
import signal
import subprocess
from contextlib import AsyncExitStack, asynccontextmanager
from os import environ
from pathlib import Path
from sys import exit

logger = logging.getLogger(__name__)


def fatal_error(msg: str):
    logger.error(msg)
    exit(1)


@asynccontextmanager
async def virtiofsd(virtiofs_dir: Path, tag: str, source: Path, cache: str, flag: str):
    socket_path = virtiofs_dir / tag
    proc = await asyncio.create_subprocess_exec(
        "@virtiofsd@",
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

    loop = asyncio.get_running_loop()
    while not await loop.run_in_executor(None, lambda: socket_path.exists()):
        if proc.returncode is not None:
            fatal_error(f"virtiofsd process for '{tag}' failed to start. Aborting.")
        await asyncio.sleep(1)

    yield

    try:
        proc.terminate()
        async with asyncio.timeout(2):
            await proc.communicate()
    except ProcessLookupError:
        pass
    except subprocess.TimeoutExpired:
        logger.warning(
            f"virtiofsd process for '{tag}' still running after SIGTERM. Killing."
        )
        proc.kill()
        await proc.communicate()


def extract_arguments() -> tuple[list[tuple[str, Path, str, str]], list[str]]:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--virtiofs-paths",
        nargs="+",
        help="Paths to be exposed with virtiofsd in the format 'tag:source:mode:cache'",
    )

    args, qemu_args = parser.parse_known_args()
    if not qemu_args:
        logger.warning("No command to run specified, exiting")
        exit(0)

    if qemu_args[0] != "--":
        fatal_error(
            "Usage error: expected command to run separated with '--' from the args pased to this program!"
        )
    qemu_args.pop(0)
    if not qemu_args:
        logger.warning("No command to run specified, exiting")
        exit(0)

    defs = []
    for defin in args.virtiofs_paths:
        args = defin.split(":")
        if len(args) != 4:
            fatal_error(
                f"--virtio-paths definition '{defin}' doesn't have four params separated by ':'!"
            )
        defs.append((args[0], Path(args[1]), args[2], args[3]))

    return defs, qemu_args


async def amain():
    logging.basicConfig(format="%(levelname)s: %(funcName)s: %(message)s")
    args, qemu_args = extract_arguments()

    try:
        virtiofs_dir = Path(environ["NIX_VIRTIOFS_DIR"])
    except KeyError:
        fatal_error("NIX_VIRTIOFS_DIR is unset!")

    async with AsyncExitStack() as virtiofsds:
        await asyncio.gather(
            *(
                virtiofsds.enter_async_context(virtiofsd(virtiofs_dir, *defin))
                for defin in args
            )
        )

        proc = await asyncio.create_subprocess_exec(*qemu_args)
        loop = asyncio.get_running_loop()
        loop.add_signal_handler(signal.SIGTERM, lambda: proc.terminate())
        loop.add_signal_handler(signal.SIGINT, lambda: proc.terminate())
        await proc.communicate()


def main():
    asyncio.run(amain())


if __name__ == "__main__":
    asyncio.run(main())
