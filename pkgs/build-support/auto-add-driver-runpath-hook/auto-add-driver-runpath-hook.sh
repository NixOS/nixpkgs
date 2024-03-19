# shellcheck shell=bash
# Run addDriverRunpath on all dynamically linked, ELF files
echo "Sourcing auto-add-driver-runpath-hook"

elfHasDynamicSection() {
    patchelf --print-rpath "$1" >& /dev/null
}

autoAddDriverRunpathPhase() (
  local outputPaths
  mapfile -t outputPaths < <(for o in $(getAllOutputNames); do echo "${!o}"; done)
  find "${outputPaths[@]}" -type f -print0  | while IFS= read -rd "" f; do
    if isELF "$f"; then
      # patchelf returns an error on statically linked ELF files
      if elfHasDynamicSection "$f" ; then
        echo "autoAddDriverRunpathHook: patching $f"
        addDriverRunpath "$f"
      elif (( "${NIX_DEBUG:-0}" >= 1 )) ; then
        echo "autoAddDriverRunpathHook: skipping a statically-linked ELF file $f"
      fi
    fi
  done
)

# Emit warning during build that this has been renamed
if [ -n "${dontUseAutoAddOpenGLRunpath-}" ]; then
    echo "dontUseAutoAddOpenGLRunpath has been deprecated, please use dontUseAutoAddDriverRunpath instead"
fi

# Respect old toggle value to allow for people to gracefully transition
if [ -z "${dontUseAutoAddDriverRunpath-}" -a -z "${dontUseAutoAddOpenGLRunpath-}" ]; then
  echo "Using autoAddDriverRunpathPhase"
  postFixupHooks+=(autoAddDriverRunpathPhase)
fi
