import logging
import os
from pathlib import Path
from tempfile import TemporaryDirectory
from typing import Final

logger: Final = logging.getLogger(__name__)

# The Linux kernel hardcodes a limit of 108 bytes for Unix sockets [0],
# but that includes one NULL byte at the very end, so the logical max
# length is 107 bytes.
# [0]: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/include/uapi/linux/un.h?h=v6.18.37#n7
LINUX_MAX_SOCKET_LENGTH: Final = 107

# OpenSSH expands %C to `conn_hash_hex` [0],
# which is the result of calling `ssh_connection_hash` [1],
# which computes a sha1 digest [2],
# which is 20 bytes long [3].
# which gets hex encoded [4] to double that length [5].
#
# [0]: https://github.com/openssh/openssh-portable/blob/V_10_3_P1/sshconnect.h#L70
# [1]: https://github.com/openssh/openssh-portable/blob/V_10_3_P1/ssh.c#L1464-L1465
# [2]: https://github.com/openssh/openssh-portable/blob/V_10_3_P1/readconf.c#L345
# [3]: https://github.com/openssh/openssh-portable/blob/V_10_3_P1/openbsd-compat/sha1.h#L15
# [4]: https://github.com/openssh/openssh-portable/blob/V_10_3_P1/readconf.c#L360
# [5]: https://github.com/openssh/openssh-portable/blob/V_10_3_P1/misc.c#L1627
OPENSSH_PERCENT_C_LENGTH: Final = 40

# OpenSSH adds a suffix to the given control path [0].
# There's 1 character for a `.` separator, followed by 16 random characters [1].
# [0]: https://github.com/openssh/openssh-portable/blob/V_10_3_P1/mux.c#L1348
# [1]: https://github.com/openssh/openssh-portable/blob/V_10_3_P1/mux.c#L1324
OPENSSH_CONTROL_PATH_SUFFIX_LENGTH: Final = 1 + 16

# Carefully compute a maximum allowed length for a tmpdir, otherwise ssh crashes with errors like this:
# > unix_listener: path "/home/runner/work/_temp/nixos-rebuild.aw8hzmq7/ssh-ea7c10de83787b1dec3f06ef20ee26b38c6bb0a5.x9MDykk4gmASsl3R"
# > too long for Unix domain socket
#
# The full path to our tmpdir must be short enough for the resulting Unix domain
# sockets that OpenSSH creates to fit within `LINUX_MAX_SOCKET_LENGTH`.
# It's common for system configured temp dirs to be more
# than a few characters:
# - macOS sets long TMPDIR paths.
# - Nix dev shells set a longer TMPDIR
# - GitHub actions set TMPDIR to something like `/home/runner/work/_temp`.
#
# Breaking down the socket path into its component pieces:
#
# /home/runner/work/_temp/nixos-rebuild.aw8hzmq7/ssh-ea7c10de83787b1dec3f06ef20ee26b38c6bb0a5.x9MDykk4gmASsl3R
# |-------------- TMPDIR ----------------------|^|----------------- ssh-%C -----------------||---------------|
#                                               |                                                   |
#                                Note the path separator character.                   OPENSSH_CONTROL_PATH_SUFFIX_LENGTH
#
MAX_TMPDIR_LENGTH: Final = (
    LINUX_MAX_SOCKET_LENGTH
    - 1  # Path separator between tmpdir and the socket name.
    # Keep the following in sync with `SSH_CONTROL_PATH`.
    - len("ssh-")
    - OPENSSH_PERCENT_C_LENGTH
    - OPENSSH_CONTROL_PATH_SUFFIX_LENGTH
)


def make_tmpdir() -> TemporaryDirectory[str]:
    prefix = "nixos-rebuild."
    tmpdir = TemporaryDirectory(prefix=prefix)
    if len(os.fsencode(tmpdir.name)) > MAX_TMPDIR_LENGTH:
        short_tmpdir = TemporaryDirectory(prefix=prefix, dir="/tmp")
        logger.debug(
            "tempdir '%s' exceeds %s bytes limit, defaulting to '%s' instead",
            tmpdir,
            MAX_TMPDIR_LENGTH,
            short_tmpdir,
        )

        tmpdir.cleanup()
        return short_tmpdir

    return tmpdir


TMPDIR: Final = make_tmpdir()
TMPDIR_PATH: Final = Path(TMPDIR.name)

# Keep this in sync with `MAX_TMPDIR_LENGTH`!
SSH_CONTROL_PATH: Final = str(TMPDIR_PATH / "ssh-%C")
