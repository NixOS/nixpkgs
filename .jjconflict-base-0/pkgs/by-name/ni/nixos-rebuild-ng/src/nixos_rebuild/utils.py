from __future__ import annotations

import sys
from functools import partial
from typing import Any

info = partial(print, file=sys.stderr)


def dict_to_flags(d: dict[str, Any]) -> list[str]:
    flags = []
    for key, value in d.items():
        flag = f"--{'-'.join(key.split('_'))}"
        match value:
            case None | False:
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
