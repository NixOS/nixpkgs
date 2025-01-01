import logging
from typing import TypeAlias, override

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


def dict_to_flags(d: dict[str, Args]) -> list[str]:
    flags = []
    for key, value in d.items():
        flag = f"--{'-'.join(key.split('_'))}"
        match value:
            case None | False | 0 | []:
                continue
            case True:
                flags.append(flag)
            case int():
                flags.append(f"-{key[0] * value}")
            case str():
                flags.append(flag)
                flags.append(value)
            case list():
                flags.append(flag)
                for v in value:
                    flags.append(v)
    return flags
