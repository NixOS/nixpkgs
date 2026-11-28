"""Interactive session for debugging an image test.

IPython's `loop_runner` hook forwards awaited expressions to the driver's loop,
so `await machine.succeed(...)` works.
"""

import asyncio
import threading
from typing import Any

from test_driver.logger import AbstractLogger


class InteractiveSession:
    """Run the driver's event loop in a thread and hand the prompt to IPython.

    Usage:

        session = InteractiveSession(driver)
        session.run()          # returns when the user exits the prompt

    The machines stay up for the whole session, so after leaving the prompt the
    VM is still running and can be reached with the ssh command the driver
    prints.
    """

    def __init__(self, driver: Any, logger: AbstractLogger) -> None:
        self.driver = driver
        self.logger = logger
        self.loop = asyncio.new_event_loop()
        self._ready = threading.Event()
        self._thread: threading.Thread | None = None

    def _run_loop(self) -> None:
        asyncio.set_event_loop(self.loop)
        self.loop.call_soon(self._ready.set)
        self.loop.run_forever()

    def start(self) -> None:
        if self._thread is not None:
            return
        self._thread = threading.Thread(
            target=self._run_loop, name="image-test-loop", daemon=True
        )
        self._thread.start()
        self._ready.wait()

    def stop(self) -> None:
        if self._thread is None:
            return
        self.loop.call_soon_threadsafe(self.loop.stop)
        self._thread.join()
        self._thread = None

    def submit(self, coroutine: Any) -> Any:
        """Run a coroutine on the driver loop and wait for its result."""
        future = asyncio.run_coroutine_threadsafe(coroutine, self.loop)
        return future.result()

    async def _enter_machines(self) -> None:
        await self.driver.__aenter__()

    async def _exit_machines(self) -> None:
        await self.driver.__aexit__(None, None, None)

    def run(self) -> None:
        self.start()
        try:
            self.submit(self._enter_machines())
            namespace = self.driver.symbols()
            self._run_prompt(namespace)
        finally:
            try:
                self.submit(self._exit_machines())
            finally:
                self.stop()
            self._print_shutdown(self.driver)

    def _run_prompt(self, namespace: dict[str, Any]) -> None:
        import IPython
        from IPython.core.interactiveshell import InteractiveShell

        shell = InteractiveShell.instance()
        shell.user_ns.update(namespace)
        shell.loop_runner = self.submit
        shell.autoawait = True

        self.logger.info(
            "The machines are running. Commands are coroutines, so prefix them "
            "with `await`, e.g. `await machine.succeed('true')`."
        )
        try:
            IPython.embed(user_ns=shell.user_ns, using=shell)
        except TypeError:
            IPython.embed(user_ns=shell.user_ns)

    def _print_shutdown(self, driver: Any) -> None:
        for name in driver.machines:
            self.logger.info(f"machine {name} has been shut down")
