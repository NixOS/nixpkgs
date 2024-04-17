# shellcheck shell=bash
# Run addDriverRunpath on all dynamically linked, ELF files
echo "Sourcing auto-add-driver-runpath-hook"

if [ -n "${dontUseAutoAddOpenGLRunpath-}" ]; then
  echo "dontUseAutoAddOpenGLRunpath has been deprecated, please use dontUseAutoAddDriverRunpath instead"
fi

# Respect old toggle value to allow for people to gracefully transition
# See: https://github.com/NixOS/nixpkgs/issues/141803 for transition roadmap
if [ -z "${dontUseAutoAddDriverRunpath-}" -a -z "${dontUseAutoAddOpenGLRunpath-}" ]; then
  echo "Using autoAddDriverRunpath"
  postFixupHooks+=("autoFixElfFiles addDriverRunpath")
fi
