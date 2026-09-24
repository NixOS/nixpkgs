#!/bin/sh
set -eu

state_home="${XDG_STATE_HOME:-${HOME:?HOME must be set}/.local/state}"
state_dir="$state_home/openlinkhub"
@coreutils@/mkdir -p "$state_dir"
@out@/libexec/openlinkhub-provision "$state_dir"
cd "$state_dir"
exec @out@/opt/OpenLinkHub/OpenLinkHub
