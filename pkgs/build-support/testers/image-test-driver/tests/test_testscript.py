import asyncio

import pytest

from image_test_driver.testscript import (
    ScriptError,
    compile_test_script,
    format_exception,
    run_test_script,
)


def run(source, **namespace):
    async def go():
        return await run_test_script(source, {"asyncio": asyncio, **namespace})

    return asyncio.run(go())


def test_awaits_at_top_level():
    seen = []

    async def record(value):
        seen.append(value)

    run("await record(1)\nawait record(2)\n", record=record)
    assert seen == [1, 2]


def test_definitions_and_sync_code_run():
    run(
        "def double(x):\n"
        "    return x * 2\n"
        "\n"
        "assert double(2) == 4\n"
        "await asyncio.sleep(0)\n"
    )


def test_script_without_await_is_rejected():
    with pytest.raises(ScriptError, match="no `await`"):
        compile_test_script("machine.succeed('true')\n")


def test_rejection_points_at_nixos_tests():
    with pytest.raises(ScriptError, match="runNixOSTest"):
        compile_test_script("print('hi')\n")


def test_syntax_error_reports_line():
    with pytest.raises(ScriptError) as excinfo:
        compile_test_script("await asyncio.sleep(0)\ndef (:\n")
    assert excinfo.value.lineno == 2


def test_traceback_shows_the_script_line_and_source():
    async def boom():
        raise ValueError("nope")

    async def go():
        try:
            await run_test_script(
                "await asyncio.sleep(0)\nawait boom()\n",
                {"asyncio": asyncio, "boom": boom},
            )
        except ValueError as exc:
            return format_exception(exc)
        raise AssertionError("expected a failure")

    text = asyncio.run(go())
    assert "<image-test>" in text
    assert "line 2" in text
    assert "await boom()" in text
    assert "base_events" not in text


async def test_subtest_groups_but_propagates():
    class Machine:
        pass

    from test_driver.logger import CompositeLogger

    from image_test_driver.machine.base import BaseMachine

    machine = BaseMachine(name="m", logger=CompositeLogger([]), out_dir=None)
    async with machine.subtest("outer"):
        pass

    with pytest.raises(RuntimeError):
        async with machine.subtest("failing"):
            raise RuntimeError("boom")


def write_config(tmp_path, script):
    import json

    config = tmp_path / "config.json"
    config.write_text(
        json.dumps({"machines": {}, "global_timeout": 30, "test_script": str(script)})
    )
    return config


def test_failing_script_exits_nonzero(tmp_path):
    """A failing test must fail the build."""
    import subprocess
    import sys

    script = tmp_path / "script.py"
    script.write_text("await asyncio.sleep(0)\nraise AssertionError('nope')\n")
    config = write_config(tmp_path, script)
    proc = subprocess.run(
        [sys.executable, "-m", "image_test_driver.cli", "--config", str(config)],
        capture_output=True,
        text=True,
    )
    assert proc.returncode == 1, proc.stdout + proc.stderr
    assert "AssertionError: nope" in proc.stderr
    assert "<image-test>" in proc.stderr
    assert "base_events" not in proc.stderr


def test_passing_script_exits_zero(tmp_path):
    import subprocess
    import sys

    script = tmp_path / "script.py"
    script.write_text("await asyncio.sleep(0)\n")
    config = write_config(tmp_path, script)
    proc = subprocess.run(
        [sys.executable, "-m", "image_test_driver.cli", "--config", str(config)],
        capture_output=True,
        text=True,
    )
    assert proc.returncode == 0, proc.stdout + proc.stderr
