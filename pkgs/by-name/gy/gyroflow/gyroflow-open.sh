#!/usr/bin/env bash
if [ "$#" -ge 1 ]; then
    exec "$(dirname "$0")"/gyroflow --open "$@"
else
    exec "$(dirname "$0")"/gyroflow "$@"
fi
