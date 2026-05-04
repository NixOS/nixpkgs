# This file contains type hints that can be prepended to Nix test scripts so they can be type
# checked.

from contextlib import contextmanager
from typing import Any, Callable, ContextManager, Generator, List, Optional, Union
from unittest import TestCase

from test_driver.debug import DebugAbstract, DebugNop
from test_driver.driver import Driver
from test_driver.logger import AbstractLogger, CompositeLogger
from typing_extensions import Protocol

from test_driver.machine import BaseMachine, NspawnMachine, QemuMachine
from test_driver.vlan import VLan


# Protocols


class CreateMachineProtocol(Protocol):
    def __call__(
        self,
        start_command: str | dict,
        *,
        name: Optional[str] = None,
        keep_machine_state: bool = False,
        **kwargs: Any,  # to allow usage of deprecated keep_vm_state
    ) -> QemuMachine:
        raise Exception("This is just type information for the Nix test driver")


class PollingConditionProtocol(Protocol):
    def __call__(
        self,
        fun_: Optional[Callable] = None,
        *,
        seconds_interval: float = 2.0,
        description: Optional[str] = None,
    ) -> Union[Callable[[Callable], ContextManager], ContextManager]:
        raise Exception("This is just type information for the Nix test driver")


# Classes


class AssertionTester(TestCase):
    pass


# Global Variables

debug: DebugAbstract = DebugNop()
machines: List[BaseMachine] = []
machines_nspawn: List[NspawnMachine] = []
machines_qemu: List[QemuMachine] = []
t = AssertionTester()
vlans: List[VLan] = []


def create_fake_driver() -> Driver:
    raise Exception("fake driver")


driver = create_fake_driver()


# Functions


# these are going to be called by the testScriptWithTypes in driver.nix
def create_fake_qemu_machine() -> QemuMachine:
    raise Exception("fake qemu machine")


def create_fake_nspawn_machine() -> NspawnMachine:
    raise Exception("fake nspawn machine")


def create_fake_vlan() -> VLan:
    raise Exception("fake vlan")


def create_machine(
    start_command: str, name: str | None = None, keep_machine_state: bool = False
) -> QemuMachine:
    raise Exception("fake machine")


def dump_machine_ssh() -> None:
    return None


def join_all() -> None:
    return None


log: AbstractLogger = CompositeLogger([])


def polling_condition(
    fun: Callable | None, seconds_interval: float = 0.0, description: str | None = None
):
    pass


def retry(fn: Callable, timeout_seconds: int = 900) -> None:
    pass


def run_tests() -> None:
    return


def serial_stdout_off() -> None:
    return None


def serial_stdout_on() -> None:
    return None


def start_all() -> None:
    return


def test_script() -> None:
    return


@contextmanager
def subtest(str: str) -> Generator[None, None, None]:
    yield
