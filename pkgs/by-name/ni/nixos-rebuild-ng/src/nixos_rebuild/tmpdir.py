import logging
from pathlib import Path
from tempfile import TemporaryDirectory, gettempdir
from typing import Final

logger: Final = logging.getLogger(__name__)


# Very long tmp dirs lead to "too long for Unix domain socket"
# SSH ControlPath errors. Especially macOS sets long TMPDIR paths.
# This is also required for Linux, if the user tries to build
# from inside a shell using `--target-host`, which will cause
# ssh to fail with "ControlPath too long"
#
# The constant is based on a worst case example FQDN, e.g.:
# `ec2-123-123-123-123.ap-southeast-2.compute.amazonaws.com` (56 bytes).
# The `ControlPath` can maximum be 108 bytes. Given the prefix
# that is used for the tempdir, ie. `nixos-rebuild.47i6dz8c` (22 bytes),
# we have 30 bytes left to work with.
# This should be fine for the usual temp folders:
# /tmp/tmp.7hBqN2Fm5H (19)
# /var/tmp/tmp.7hBqN2Fm5H (23)
# /run/user/1000/tmp.7hBqN2Fm5H (29)
def make_tmpdir() -> TemporaryDirectory[str]:
    tmp = gettempdir()
    if len(tmp) >= 30:
        logger.debug(
            "tempdir '%s' exceeds 30 bytes limit, defaulting to /tmp instead",
            tmp,
        )

        return TemporaryDirectory(prefix="nixos-rebuild.", dir="/tmp")

    return TemporaryDirectory(prefix="nixos-rebuild.")


TMPDIR: Final = make_tmpdir()
TMPDIR_PATH: Final = Path(TMPDIR.name)
