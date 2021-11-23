# shellcheck shell=bash
# Fixup hook for nukeReferences, not stdenv

source @signingUtils@

fixupHooks+=(signIfRequired)
