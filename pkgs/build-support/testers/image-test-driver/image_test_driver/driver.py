"""Run one image test script against one or more virtual machines."""

import asyncio
import contextlib
import pathlib
from typing import Any

from test_driver.errors import MachineError
from test_driver.logger import AbstractLogger

from image_test_driver import config as config_module
from image_test_driver import testscript
from image_test_driver.machine.base import BaseMachine
from image_test_driver.machine.qemu import QemuMachine


def make_machine(
    machine_config: config_module.MachineConfiguration,
    *,
    logger: AbstractLogger,
    out_dir: pathlib.Path,
) -> BaseMachine:
    """Instantiate the backend for a given machine configuration."""
    if machine_config.backend == "qemu":
        return QemuMachine(
            name=machine_config.name,
            image=machine_config.image,
            logger=logger,
            out_dir=out_dir,
            cpus=machine_config.cpus,
            memory=machine_config.memory,
            boot=machine_config.boot,
            snapshot=machine_config.snapshot,
            networking=machine_config.networking,
            credentials=machine_config.credentials,
            cloud_init=machine_config.cloud_init,
            timeout=machine_config.boot_timeout,
        )
    raise ValueError(f"unknown backend {machine_config.backend!r}")


class Driver:
    def __init__(
        self,
        config: config_module.DriverConfiguration,
        *,
        logger: AbstractLogger,
        out_dir: pathlib.Path,
    ) -> None:
        self.config = config
        self.logger = logger
        self.out_dir = out_dir
        self.machines: dict[str, BaseMachine] = {}
        self._exit_stack: contextlib.AsyncExitStack | None = None

    async def __aenter__(self) -> "Driver":
        self._exit_stack = contextlib.AsyncExitStack()
        await self._exit_stack.__aenter__()
        # A machine's lifetime is the whole test.
        for name, machine_config in self.config.machines.items():
            machine = make_machine(
                machine_config, logger=self.logger, out_dir=self.out_dir
            )
            self.machines[name] = await self._exit_stack.enter_async_context(machine)
        return self

    async def __aexit__(self, *exc_info: Any) -> None:
        assert self._exit_stack is not None
        await self._exit_stack.__aexit__(*exc_info)

    def symbols(self) -> dict[str, Any]:
        """The globals a test script sees."""
        symbols: dict[str, Any] = {
            "asyncio": asyncio,
            "driver": self,
            "machines": list(self.machines.values()),
        }
        symbols.update(self.machines)
        if len(self.machines) == 1 and "machine" not in symbols:
            symbols["machine"] = next(iter(self.machines.values()))
        return symbols

    async def run(self) -> None:
        source = self.config.test_script.read_text()
        timeout_seconds = self.config.global_timeout.total_seconds()
        self.logger.info(
            f"Test will time out and terminate in {timeout_seconds} seconds"
        )
        try:
            async with asyncio.timeout(timeout_seconds):
                await testscript.run_test_script(source, self.symbols())
        except TimeoutError:
            raise MachineError(
                f"the test did not finish within {timeout_seconds} seconds"
            ) from None
