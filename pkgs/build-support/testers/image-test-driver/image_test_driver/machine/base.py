"""The machine handle a test script drives.

The method names match the NixOS test driver's, but every method is a coroutine.
"""

import asyncio
import contextlib
import datetime as dt
import shlex
from collections.abc import AsyncGenerator
from typing import Any, Self

from test_driver.duration import Duration, as_seconds
from test_driver.errors import MachineError, RequestedAssertionFailed
from test_driver.logger import AbstractLogger

# Re-exported so a test script only has to import one module.
__all__ = ["BaseMachine", "MachineError", "RequestedAssertionFailed"]


class BaseMachine:
    """Transport-level operations shared by every backend.

    See the `NotImplementedError`-raising function for what is required to implement.
    """

    name: str
    logger: AbstractLogger

    def __init__(self, *, name: str, logger: AbstractLogger, out_dir: Any) -> None:
        self.name = name
        self.logger = logger
        self.out_dir = out_dir

    def log(self, message: str) -> None:
        self.logger.log(message, {"machine": self.name})

    def nested(self, message: str, attrs: dict[str, str] | None = None):
        return self.logger.nested(message, {"machine": self.name, **(attrs or {})})

    @contextlib.asynccontextmanager
    async def subtest(self, name: str) -> AsyncGenerator[None]:
        """Group log output under a heading, the way NixOS tests do."""
        with self.logger.subtest(name):
            yield

    async def _run(
        self, argv: list[str], *, input: bytes | None = None
    ) -> tuple[int, bytes]:
        raise NotImplementedError

    async def start(self) -> None:
        raise NotImplementedError

    async def shutdown(self) -> None:
        raise NotImplementedError

    async def execute(
        self,
        command: str,
        *,
        deadline: Duration | None = dt.timedelta(minutes=15),
    ) -> tuple[int, str]:
        """Run a shell command, returning `(status, output)`.

        The command runs under `bash -c 'set -euo pipefail; ...'` so that the
        shell semantics match the NixOS driver's.
        """
        script = f"set -euo pipefail; {command}"
        argv = ["bash", "-c", script]
        try:
            if deadline is None:
                status, output = await self._run(argv)
            else:
                async with asyncio.timeout(as_seconds(deadline)):
                    status, output = await self._run(argv)
        except TimeoutError as exc:
            assert deadline is not None  # only the branch above can time out
            raise MachineError(
                f"{self.name}: command timed out after {as_seconds(deadline)}s: "
                f"{command}"
            ) from exc
        return status, output.decode(errors="replace")

    async def succeed(
        self,
        command: str,
        *,
        deadline: Duration | None = dt.timedelta(minutes=15),
    ) -> str:
        """Run a command, raising if its exit status is not zero."""
        with self.nested(f"must succeed: {command}"):
            status, output = await self.execute(command, deadline=deadline)
            if status != 0:
                self.log(f"output: {output}")
                raise RequestedAssertionFailed(
                    f"command `{command}` failed (exit code {status})"
                )
            return output

    async def fail(
        self,
        command: str,
        *,
        deadline: Duration | None = dt.timedelta(minutes=15),
    ) -> str:
        """Run a command, raising if its exit status *is* zero."""
        with self.nested(f"must fail: {command}"):
            status, output = await self.execute(command, deadline=deadline)
            if status == 0:
                raise RequestedAssertionFailed(
                    f"command `{command}` unexpectedly succeeded"
                )
            return output

    async def wait_until_succeeds(
        self,
        command: str,
        *,
        deadline: Duration = dt.timedelta(minutes=15),
        interval: float = 1.0,
    ) -> str:
        """Retry a command until it succeeds or the timeout expires."""
        with self.nested(
            f"waiting for success: {command} (deadline {as_seconds(deadline)}s)"
        ):
            _until = asyncio.get_running_loop().time() + as_seconds(deadline)
            last_output = ""
            while True:
                status, last_output = await self.execute(command, deadline=None)
                if status == 0:
                    return last_output
                if asyncio.get_running_loop().time() >= _until:
                    self.log(f"last output: {last_output}")
                    raise RequestedAssertionFailed(
                        f"command `{command}` did not succeed within "
                        f"{as_seconds(deadline)}s"
                    )
                await asyncio.sleep(interval)

    async def wait_until_fails(
        self,
        command: str,
        *,
        deadline: Duration = dt.timedelta(minutes=15),
        interval: float = 1.0,
    ) -> str:
        """Retry a command until it fails or the timeout expires."""
        with self.nested(
            f"waiting for failure: {command} (deadline {as_seconds(deadline)}s)"
        ):
            _until = asyncio.get_running_loop().time() + as_seconds(deadline)
            while True:
                status, output = await self.execute(command, deadline=None)
                if status != 0:
                    return output
                if asyncio.get_running_loop().time() >= _until:
                    raise RequestedAssertionFailed(
                        f"command `{command}` still succeeded after "
                        f"{as_seconds(deadline)}s"
                    )
                await asyncio.sleep(interval)

    async def wait_for_file(
        self,
        path: str,
        *,
        deadline: Duration = dt.timedelta(minutes=15),
    ) -> None:
        await self.wait_until_succeeds(
            f"test -e {shlex.quote(path)}", deadline=deadline
        )

    async def sleep(self, duration: Duration) -> None:
        """Sleep in guest time"""
        await self.succeed(f"sleep {as_seconds(duration)}")

    async def copy_from_host(self, source: str, target: str) -> None:
        raise NotImplementedError

    async def copy_from_machine(self, source: str, target_dir: str = "") -> None:
        raise NotImplementedError

    async def reboot(self) -> None:
        raise NotImplementedError

    async def __aenter__(self) -> Self:
        await self.start()
        return self

    async def __aexit__(self, *exc_info: Any) -> None:
        await self.shutdown()
