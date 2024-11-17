from __future__ import annotations

import os
import subprocess
from typing import Any, Sequence

from .models import SSH


def run(
    args: Sequence[str | bytes | os.PathLike[Any]],
    # make `check` explicit so we always know if the code is aborting on errors
    check: bool,
    remote: SSH | None = None,
    sudo: bool = False,
    **kwargs: Any,
) -> subprocess.CompletedProcess[Any]:
    if sudo:
        args = ["sudo"] + list(args)
    if remote:
        args = ["ssh", *remote.opts, remote.host, "--"] + list(args)
    return subprocess.run(args, check=check, **kwargs)
