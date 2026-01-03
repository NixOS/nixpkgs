from typing import Tuple

from markdown_it.token import Token

LineSpan = int | Tuple[int, int] | Token


class SrcError(Exception):
    """An error associated with a source file and location."""

    def __init__(
        self,
        *,
        description: str,
        src: str,
        tokens: dict[str, LineSpan] | None = None,
        token: LineSpan | None = None,
    ):
        """Create a new `SrcError`.

        Arguments:
        - `description`: A description of the error.

        - `src`: The source text the `token`s are from.

        - `tokens`: A dictionary from descriptions to `Tokens` (or lines) associated with
          the error.

          The tokens are used for their source location.

          A location like ` at lines 6-9` will be added to the description.

          If the description is empty, the location will be described as `At
          lines 6-9`.

        - `token`: Shorthand for `tokens={"": token}`.
        """
        self.src = src

        tokens = tokens or {}
        if token:
            tokens[""] = token
        self.tokens = tokens

        self.description = description

        self.message = _src_error_str(src=src, tokens=tokens, description=description)

        super().__init__(self.message)

    def __str__(self) -> str:
        return self.message


def _get_line_span(location: LineSpan) -> Tuple[int, int] | None:
    if isinstance(location, Token):
        if location.map:
            return (location.map[0], location.map[1])
        else:
            return None
    elif isinstance(location, int):
        return (location, location + 1)
    else:
        return location


def _src_error_str(*, src: str, tokens: dict[str, LineSpan], description: str) -> str:
    """Python exceptions are a bit goofy and need a `message` string attribute
    right away, so we basically need a way to generate the string before we
    actually finish `__init__`.
    """

    result = [description]

    src_lines = src.splitlines()

    for description, token in tokens.items():
        result.append("\n\n\x1b[33m")

        if description:
            result.append(description)
            result.append(" at ")
        else:
            result.append("At ")

        maybe_span = _get_line_span(token)

        if not maybe_span:
            result.append("unknown location\x1b[0m")
            continue

        start, end = maybe_span
        # Note: `end` is exclusive, so single-line spans are represented as
        # `(n, n+1)`.
        if start == end - 1:
            result.append("line ")
            result.append(str(start + 1))
        else:
            result.append("lines ")
            result.append(str(start + 1))
            result.append("-")
            result.append(str(end))

        result.append(":\x1b[0m\n")

        result.append(src_excerpt(src_lines=src_lines, start=start, end=end))

    return "".join(result)


def src_excerpt(
    *, src_lines: list[str], start: int, end: int, context: int = 3, max_lines: int = 20
) -> str:
    output = []

    def clamp_line(line_num: int) -> int:
        return max(0, min(len(src_lines), line_num))

    def add_line(line_num: int, *, is_context: bool) -> None:
        # Lines start with the line number, dimmed.
        prefix = "\x1b[2m\x1b[37m" + format(line_num + 1, " 4d") + "\x1b[0m"

        # Context lines are prefixed with a dotted line, non-context lines are
        # prefixed with a bold yellow line.
        if is_context:
            # Note: No reset here because context lines are dimmed.
            prefix += " \x1b[2m\x1b[37m┆ "
        else:
            prefix += " \x1b[1m\x1b[33m┃\x1b[0m "

        output.append(prefix + src_lines[line_num] + "\x1b[0m")

    def add_lines(start: int, end: int, is_context: bool) -> None:
        for i in range(clamp_line(start), clamp_line(end)):
            add_line(i, is_context=is_context)

    if end - start > max_lines:
        # If we have more than `max_lines` in the range, show a `...` in the middle.
        half_max_lines = max_lines // 2

        add_lines(start - context, start, is_context=True)
        add_lines(start, start + half_max_lines, is_context=False)

        output.append("     \x1b[2m\x1b[37m...\x1b[0m")

        add_lines(end - half_max_lines, end, is_context=False)
        add_lines(end, end + context, is_context=True)

    else:
        add_lines(start - context, start, is_context=True)
        add_lines(start, end, is_context=False)
        add_lines(end, end + context, is_context=True)

    return "\n".join(output)
