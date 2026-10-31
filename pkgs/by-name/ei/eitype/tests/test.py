import argparse
import asyncio
import re
from asyncio.subprocess import Process
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager
from pathlib import Path


@asynccontextmanager
async def process(*args: str, stdout: int | None = None) -> AsyncIterator[Process]:
    child = await asyncio.create_subprocess_exec(*args, stdout=stdout)
    try:
        yield child
    finally:
        if child.returncode is None:
            child.terminate()
        await child.wait()


async def read_events(server: Process, ready: asyncio.Event) -> list[tuple[int, str]]:
    assert server.stdout is not None
    events: list[tuple[int, str]] = []
    async for line in server.stdout:
        text = line.decode()
        print(text, end="", flush=True)
        if "waiting on " in text:
            ready.set()
        if match := re.search(r"key (\d+) \((press|release)\)", text):
            events.append((int(match[1]), match[2]))
        if "client eitype disconnected" in text:
            return events
    raise RuntimeError("EIS server exited before the client disconnected")


async def run_client(eitype: str, *connection: str) -> None:
    async with process(
        eitype, *connection, "--layout-index", "0", "aA", "-k", "return"
    ) as client:
        assert await client.wait() == 0


async def test(args: argparse.Namespace) -> None:
    socket = Path("eis.sock").absolute()
    ready = asyncio.Event()
    async with (
        process(
            "stdbuf",
            "-oL",
            args.server,
            "--socketpath",
            str(socket),
            "--layout",
            "us",
            stdout=asyncio.subprocess.PIPE,
        ) as server,
        asyncio.TaskGroup() as tasks,
    ):
        events = tasks.create_task(read_events(server, ready))
        await ready.wait()

        if args.portal:
            from portal import PortalBackend

            async with PortalBackend(socket) as backend, process(args.portal):
                await backend.wait_for_portal()
                await run_client(args.eitype)
        else:
            await run_client(args.eitype, "--socket", str(socket))

        received = await events
        expected = [
            (30, "press"),
            (30, "release"),
            (42, "press"),
            (30, "press"),
            (30, "release"),
            (42, "release"),
            (28, "press"),
            (28, "release"),
        ]
        assert received == expected, f"Unexpected keyboard events: {received}"


async def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("eitype")
    parser.add_argument("server")
    parser.add_argument("--portal")
    async with asyncio.timeout(30):
        await test(parser.parse_args())


asyncio.run(main())
