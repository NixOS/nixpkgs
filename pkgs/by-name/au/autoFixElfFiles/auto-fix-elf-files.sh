# shellcheck shell=bash
# List all dynamically linked ELF files in the outputs and apply a generic fix
# action provided as a parameter (currently used to add the CUDA or the
# cuda_compat driver to the runpath of binaries)
echo "Sourcing fix-elf-files.sh"

# Run a fix action on all dynamically linked ELF files in the outputs.
autoFixElfFiles() {
  if (($# != 1)); then
    nixErrorLog "expected one argument!" >&2
    nixErrorLog "usage: autoFixElfFiles fixAction" >&2
    exit 1
  fi

  local -r fixAction="$1"
  local outputName
  local outputPath
  local -a outputPaths=()

  for outputName in $(getAllOutputNames); do
    outputPaths=()
    getElfFiles "${!outputName}" outputPaths
    for outputPath in "${outputPaths[@]}"; do
      nixLog "using $fixAction to fix $outputPath"
      $fixAction "$outputPath"
    done
  done
}
