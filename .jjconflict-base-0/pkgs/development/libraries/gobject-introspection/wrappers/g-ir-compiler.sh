#! @bash@/bin/bash
# shellcheck shell=bash

exec @emulatorwrapper@ @targetgir@/bin/g-ir-compiler "$@"
