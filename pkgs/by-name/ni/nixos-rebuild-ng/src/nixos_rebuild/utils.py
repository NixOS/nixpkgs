import logging
from collections.abc import Mapping, Sequence
from typing import Any, TypeAlias, assert_never, override

Args: TypeAlias = bool | str | list[str] | int | None


class LogFormatter(logging.Formatter):
    formatters = {
        logging.INFO: logging.Formatter("%(message)s"),
        logging.DEBUG: logging.Formatter("%(levelname)s: %(name)s: %(message)s"),
        "DEFAULT": logging.Formatter("%(levelname)s: %(message)s"),
    }

    @override
    def format(self, record: logging.LogRecord) -> str:
        record.levelname = record.levelname.lower()
        formatter = self.formatters.get(record.levelno, self.formatters["DEFAULT"])
        return formatter.format(record)


def dict_to_flags(d: Mapping[str, Args]) -> list[str]:
    flags = []
    for key, value in d.items():
        flag = f"--{'-'.join(key.split('_'))}"
        match value:
            case None | False | 0 | []:
                continue
            case True if len(key) == 1:
                flags.append(f"-{key}")
            case True:
                flags.append(flag)
            case int() if len(key) == 1:
                flags.append(f"-{key * value}")
            case int():
                for i in range(value):
                    flags.append(flag)
            case str():
                flags.append(flag)
                flags.append(value)
            case list():
                flags.append(flag)
                for v in value:
                    flags.append(v)
            case _:
                assert_never(value)
    return flags


def remap_dicts(
    dicts: Sequence[Mapping[str, Any]],
    mappings: Mapping[str, str],
) -> list[dict[str, Any]]:
    return [{mappings.get(k, k): v for k, v in d.items()} for d in dicts]


def tabulate(
    data: Sequence[Mapping[str, Any]],
    headers: Mapping[str, str] | None = None,
) -> str:
    """Convert a sequence of mappings in a tabular-style format for terminal.

    It expects that all mappings (dicts) have the same keys as the first one,
    otherwise it will misbehave.
    """
    if not data:
        return ""

    if headers:
        data = remap_dicts(data, headers)

    data_headers = list(data[0].keys())

    column_widths = [
        max(
            len(str(header)),
            *(len(str(row.get(header, ""))) for row in data),
        )
        for header in data_headers
    ]

    def format_row(row: Mapping[str, Any]) -> str:
        s = (2 * " ").join(
            f"{str(row[header]).ljust(width)}"
            for header, width in zip(data_headers, column_widths)
        )
        return s.strip()

    result = [format_row(dict(zip(data_headers, data_headers)))]
    for row in data:
        result.append(format_row(row))

    return "\n".join(result)
