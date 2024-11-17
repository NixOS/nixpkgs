import argparse
import sys
from functools import partial
from typing import TypeAlias

info = partial(print, file=sys.stderr)
Args: TypeAlias = bool | str | list[str] | int | None


def dict_to_flags(d: dict[str, Args]) -> list[str]:
    flags = []
    for key, value in d.items():
        flag = f"--{'-'.join(key.split('_'))}"
        match value:
            case None | False | 0 | []:
                pass
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


def flags_to_dict(args: argparse.Namespace, keys: list[str]) -> dict[str, Args]:
    d = vars(args)
    return {k: d[k] for k in keys}
