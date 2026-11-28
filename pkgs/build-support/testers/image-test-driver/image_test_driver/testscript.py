"""Compile a test script whose top level may contain `await`.

`exec()` rejects a module with a top-level `await`, so the script is wrapped in
an `async def` and compiled as one coroutine. Wrapping through the AST rather
than by rewriting text keeps the author's line numbers intact.
"""

import ast
import linecache
from collections.abc import Awaitable, Callable
from types import TracebackType
from typing import Any

SCRIPT_FILENAME = "<image-test>"


class ScriptError(Exception):
    """A test script could not be compiled."""

    def __init__(
        self, message: str, *, lineno: int | None = None, text: str | None = None
    ):
        self.lineno = lineno
        self.text = text
        if lineno is not None:
            message = f"{SCRIPT_FILENAME}:{lineno}: {message}"
        super().__init__(message)


def _check_has_await(module: ast.Module) -> None:
    """Reject a script that never awaits anything."""
    if not any(isinstance(node, ast.Await) for node in ast.walk(module)):
        raise ScriptError(
            "this test script contains no `await`.\n"
            "Image tests use an async API, so a command must be awaited, e.g.\n"
            '    await machine.succeed("true")\n'
            "If this is a synchronous NixOS test, it should use `testers.runNixOSTest`."
        )


def compile_test_script(
    source: str, namespace: dict[str, Any] | None = None
) -> Callable[[], Awaitable[None]]:
    """Compile `source` into a zero-argument callable returning a coroutine."""
    try:
        module = ast.parse(source, filename=SCRIPT_FILENAME, mode="exec")
    except SyntaxError as exc:
        raise ScriptError(
            exc.msg, lineno=exc.lineno, text=(exc.text or "").rstrip()
        ) from exc

    _check_has_await(module)

    body = module.body or [ast.Pass()]
    wrapper = ast.AsyncFunctionDef(
        name="__image_test__",
        args=ast.arguments(
            posonlyargs=[],
            args=[],
            vararg=None,
            kwonlyargs=[],
            kw_defaults=[],
            kwarg=None,
            defaults=[],
        ),
        body=body,
        decorator_list=[],
        returns=None,
        type_comment=None,
        type_params=[],
    )
    new_module = ast.Module(body=[wrapper], type_ignores=[])
    ast.fix_missing_locations(new_module)

    try:
        code = compile(new_module, SCRIPT_FILENAME, "exec")
    except SyntaxError as exc:
        raise ScriptError(
            exc.msg, lineno=exc.lineno, text=(exc.text or "").rstrip()
        ) from exc

    linecache.cache[SCRIPT_FILENAME] = (
        len(source),
        None,
        source.splitlines(keepends=True),
        SCRIPT_FILENAME,
    )

    namespace = dict(namespace or {})
    exec(code, namespace)

    return namespace["__image_test__"]


def extract_script_frames(tb: TracebackType | None) -> list[Any]:
    """Return the traceback frames that belong to the test script."""
    frames = []
    while tb is not None:
        if tb.tb_frame.f_code.co_filename == SCRIPT_FILENAME:
            frames.append(tb)
        tb = tb.tb_next
    return frames


def format_exception(exc: BaseException) -> str:
    """Format the test script's part of a traceback, plus the exception."""
    import traceback

    lines = ["Traceback (most recent call last):"]
    for tb in extract_script_frames(exc.__traceback__):
        for line in traceback.format_list(traceback.extract_tb(tb)):
            lines.append(line.rstrip())
    lines.append("".join(traceback.format_exception_only(type(exc), exc)).rstrip())
    return "\n".join(lines)


async def run_test_script(
    source: str,
    namespace: dict[str, Any],
) -> None:
    """Compile and run `source` inside the current event loop."""
    coroutine_function = compile_test_script(source, namespace)
    await coroutine_function()
