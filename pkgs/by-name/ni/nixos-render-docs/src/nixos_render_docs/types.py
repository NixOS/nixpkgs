from collections.abc import Sequence
from enum import Enum
from typing import Callable, Optional, NamedTuple

from markdown_it.token import Token

OptionLoc = str | dict[str, str]
Option = dict[str, str | dict[str, str] | list[OptionLoc]]

class RenderedOption(NamedTuple):
    loc: list[str]
    lines: list[str]
    links: Optional[list[str]] = None

RenderFn = Callable[[Token, Sequence[Token], int], str]

class AnchorStyle(Enum):
    NONE = "none"
    LEGACY = "legacy"
