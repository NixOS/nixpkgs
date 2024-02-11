#! @runtimeShell@
# shellcheck shell=bash

if [ -x "@runtimeShell@" ]; then export SHELL="@runtimeShell@"; fi;

# Runs the provided command in script(1) with logging of stdout to the systemd journal.
# This is necessary to keep the command thinking it is operating against a
# terminal while still logging the output regardless. This is split into a
# helper script to cleanly deal with shell quoting.
#
# This has been checked by some manual testing that this works fine even if the
# journal has exploded or does not exist, such as in a container, chroot or
# such cases.

LABEL=${LABEL:-nixos-rebuild}
# the cat >/dev/null is load bearing if systemd-cat fails to initialize,
# because script does not like having its output fd hang up on it, and seems to
# hang the terminal if that happens.
#
# ${*@Q} - the * array (all args as one word), with shell quoting applied (@Q modifier)
@script@ --quiet --flush --log-out >(systemd-cat -t "$LABEL" >/dev/null 2>&1 || cat >/dev/null) --command "${*@Q}"
