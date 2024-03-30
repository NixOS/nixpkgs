# shellcheck shell=bash
# List all dynamically linked ELF files in the outputs and apply a generic fix
# action provided as a parameter (currently used to add the CUDA or the
# cuda_compat driver to the runpath of binaries)
echo "Sourcing fix-elf-files.sh"

# Returns the exit code of patchelf --print-rpath.
# A return code of 0 (success) means the ELF file has a dynamic section, while
# a non-zero return code means the ELF file is statically linked (or is not an
# ELF file).
elfHasDynamicSection() {
  local libPath

  if [[ $# -eq 0 ]]; then
    echo "elfHasDynamicSection: no library path provided" >&2
    exit 1
  elif [[ $# -gt 1 ]]; then
    echo "elfHasDynamicSection: too many arguments" >&2
    exit 1
  elif [[ "$1" == "" ]]; then
    echo "elfHasDynamicSection: empty library path" >&2
    exit 1
  else
    libPath="$1"
    shift 1
  fi

  patchelf --print-rpath "$libPath" >& /dev/null
  return $?
}

# Run a fix action on all dynamically linked ELF files in the outputs.
autoFixElfFiles() {
  local fixAction
  local outputPaths

  if [[ $# -eq 0 ]]; then
    echo "autoFixElfFiles: no fix action provided" >&2
    exit 1
  elif [[ $# -gt 1 ]]; then
    echo "autoFixElfFiles: too many arguments" >&2
    exit 1
  elif [[ "$1" == "" ]]; then
    echo "autoFixElfFiles: empty fix action" >&2
    exit 1
  else
    fixAction="$1"
  fi

  mapfile -t outputPaths < <(for o in $(getAllOutputNames); do echo "${!o}"; done)

  find "${outputPaths[@]}" -type f -print0  | while IFS= read -rd "" f; do
    if ! isELF "$f"; then
      continue
    elif elfHasDynamicSection "$f"; then
      # patchelf returns an error on statically linked ELF files, and in
      # practice fixing actions all involve patchelf
      echo "autoFixElfFiles: using $fixAction to fix $f" >&2
      $fixAction "$f"
    elif (( "${NIX_DEBUG:-0}" >= 1 )); then
      echo "autoFixElfFiles: skipping a statically-linked ELF file $f"
    fi
  done
}
