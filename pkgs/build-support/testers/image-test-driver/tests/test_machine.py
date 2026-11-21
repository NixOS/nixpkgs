import asyncio

import pytest
from test_driver.errors import RequestedAssertionFailed
from test_driver.logger import CompositeLogger

from image_test_driver.machine.base import BaseMachine

logger = CompositeLogger([])


class FakeMachine(BaseMachine):
    """A machine whose `_run` answers from a script instead of a VM."""

    def __init__(self, replies):
        super().__init__(name="fake", logger=logger, out_dir=None)
        self.replies = list(replies)
        self.calls: list[list[str]] = []

    async def _run(self, argv, *, input=None):
        self.calls.append(argv)
        if not self.replies:
            raise AssertionError(f"unexpected call: {argv}")
        return self.replies.pop(0)

    async def start(self):
        pass

    async def shutdown(self):
        pass


async def test_succeed_returns_output():
    m = FakeMachine([(0, b"hello\n")])
    assert await m.succeed("echo hello") == "hello\n"


async def test_succeed_raises_on_nonzero():
    m = FakeMachine([(1, b"boom\n")])
    with pytest.raises(RequestedAssertionFailed, match="exit code 1"):
        await m.succeed("false")


async def test_fail_requires_nonzero():
    m = FakeMachine([(0, b"")])
    with pytest.raises(RequestedAssertionFailed, match="unexpectedly succeeded"):
        await m.fail("true")


async def test_commands_are_bash_with_pipefail():
    m = FakeMachine([(0, b"")])
    await m.succeed("true")
    (argv,) = m.calls
    assert argv[:2] == ["bash", "-c"]
    assert argv[2].startswith("set -euo pipefail; ")


async def test_execute_returns_status_and_output():
    m = FakeMachine([(7, b"partial")])
    assert await m.execute("exit 7") == (7, "partial")


async def test_wait_until_succeeds_retries():
    m = FakeMachine([(1, b"no"), (1, b"no"), (0, b"yes")])
    assert await m.wait_until_succeeds("probe", interval=0.01) == "yes"


async def test_wait_until_succeeds_times_out():
    m = FakeMachine([(1, b"never")] * 1000)
    with pytest.raises(RequestedAssertionFailed, match="did not succeed"):
        await m.wait_until_succeeds("probe", deadline=0.05, interval=0.01)


async def test_execute_timeout_is_reported():
    class SlowMachine(FakeMachine):
        async def _run(self, argv, *, input=None):
            await asyncio.sleep(5)
            return (0, b"")

    m = SlowMachine([])
    with pytest.raises(Exception, match="timed out"):
        await m.execute("sleep 100", deadline=0.05)


async def test_sleep_happens_in_guest_time():
    m = FakeMachine([(0, b"")])
    await m.sleep(2)
    assert "sleep 2.0" in m.calls[0][2]


class FakeVM:
    """Just enough of `testthing.VirtualMachine` to observe what is asked."""

    def __init__(self):
        self.uploaded: list[tuple[str, str]] = []
        self.executed: list[tuple[str, ...]] = []
        self.scp_calls: list[tuple[str, str]] = []

    async def upload(self, path, *, target_directory):
        self.uploaded.append((str(path), target_directory))

    async def execute(self, *args):
        self.executed.append(tuple(str(a) for a in args))
        return ""

    async def scp(self, *args):
        self.scp_calls.append(tuple(str(a) for a in args))

    def get_id(self):
        return "vm-id"


def make_qemu(tmp_path):
    from image_test_driver.machine.qemu import QemuMachine

    machine = QemuMachine(name="vm", image="/img", logger=logger, out_dir=tmp_path)
    machine._vm = FakeVM()
    return machine


async def test_copy_from_host_renames_when_name_differs(tmp_path):
    machine = make_qemu(tmp_path)
    source = tmp_path / "payload.txt"
    source.write_text("x")

    await machine.copy_from_host(str(source), "/tmp/renamed.txt")

    vm = machine._vm
    assert vm.uploaded == [(str(source), "/tmp")]
    assert vm.executed == [("mv", "/tmp/payload.txt", "/tmp/renamed.txt")]


async def test_copy_from_host_does_not_move_onto_itself(tmp_path):
    """A same-name target must not produce `mv x x`, which fails."""
    machine = make_qemu(tmp_path)
    source = tmp_path / "payload.txt"
    source.write_text("x")

    await machine.copy_from_host(str(source), "/tmp/payload.txt")

    vm = machine._vm
    assert vm.uploaded == [(str(source), "/tmp")]
    assert vm.executed == []


async def test_copy_from_machine_rejects_parent_traversal(tmp_path):
    machine = make_qemu(tmp_path)
    with pytest.raises(Exception, match="outside the output directory"):
        await machine.copy_from_machine("/etc/os-release", "../escape")


async def test_copy_from_machine_writes_under_the_output_dir(tmp_path):
    machine = make_qemu(tmp_path)
    await machine.copy_from_machine("/etc/os-release", "guests")
    assert (tmp_path / "guests").is_dir()
    assert machine._vm.scp_calls
