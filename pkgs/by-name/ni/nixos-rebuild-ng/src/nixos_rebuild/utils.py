import logging
from collections.abc import Mapping, Sequence
from typing import Any, ClassVar, assert_never, override

type Arg = bool | str | list[str] | list[list[str]] | int | None
type Args = dict[str, Arg]


class LogFormatter(logging.Formatter):
    formatters: ClassVar = {
        logging.INFO: logging.Formatter("%(message)s"),
        logging.DEBUG: logging.Formatter("%(levelname)s: %(name)s: %(message)s"),
        "DEFAULT": logging.Formatter("%(levelname)s: %(message)s"),
    }

    @override
    def format(self, record: logging.LogRecord) -> Any:
        record.levelname = record.levelname.lower()
        formatter = self.formatters.get(record.levelno, self.formatters["DEFAULT"])
        return formatter.format(record)


def dict_to_flags(d: Args | None) -> list[str]:
    if not d:
        return []

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
                for _ in range(value):
                    flags.append(flag)
            case str():
                flags.append(flag)
                flags.append(value)
            case list():
                for vs in value:
                    flags.append(flag)
                    if isinstance(vs, list):
                        for v in vs:
                            flags.append(v)
                    else:
                        flags.append(vs)
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
            for header, width in zip(data_headers, column_widths, strict=True)
        )
        return s.strip()

    result = [format_row(dict(zip(data_headers, data_headers, strict=True)))]
    for row in data:
        result.append(format_row(row))

    return "\n".join(result)
