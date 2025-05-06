#!/usr/bin/env bash

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

if [ "$#" -ge 1 ]; then
    exec "${SCRIPT_DIRECTORY}/gyroflow --open "$@"
else
    exec "${SCRIPT_DIRECTORY}/gyroflow "$@"
fi
