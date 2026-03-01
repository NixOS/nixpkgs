from pathlib import Path
from tempfile import TemporaryDirectory
from typing import Final


# Very long tmp dirs lead to "too long for Unix domain socket"
# SSH ControlPath errors. Especially macOS sets long TMPDIR paths.
# This is also required for Linux, if the user tries to build
# from inside a shell using `--target-host`, which will cause
# ssh to fail with "ControlPath too long"
def make_tmpdir() -> TemporaryDirectory[str]:
    tmp = TemporaryDirectory(prefix="nixos-rebuild.")
    if len(tmp.name) >= 60:
        tmp.cleanup()
        return TemporaryDirectory(prefix="nixos-rebuild.", dir="/tmp")
    return tmp


TMPDIR: Final = make_tmpdir()
TMPDIR_PATH: Final = Path(TMPDIR.name)
