# This setup hook, writes the derivation nixMetaJSON info
# to $output/nix-support/meta.json so package information
# can be reconstructed at runtime.


# Guard against double inclusion.
if (("${writeMetaJSONInstalled:-0}" > 0)); then
  nixInfoLog "skipping because the hook has been propagated more than once"
  return 0
fi
declare -ig writeMetaJSONInstalled=1


fixupOutputHooks+=(writeMetaInAllOutputs)

writeMetaJSON() {
  local -r output="${1:?}"
  if [[ ! -e $output ]]; then
    nixWarnLog "skipping non-existent output $output"
    return 0
  fi
  if [[ ! -d $output ]]; then
    nixWarnLog "skipping non-directory output $output"
    return 0
  fi
  if [[ -e "$output/nix-support/meta.json" ]]; then
    nixWarnLog "skipping already present meta.json"
    return 0
  fi
  mkdir -p "$output/nix-support"
  echo -n "$nixMetaJSON" >> "$output/nix-support/meta.json"
}

writeMetaInAllOutputs() {
  if [[ -z "${nixMetaJSON:-}" ]]; then
    nixWarnLog "\$nixMetaJSON not present or empty, skipping"
    return 0
  fi
    for output in $(getAllOutputNames); do
      nixInfoLog "Running write-meta-json for $output"
      writeMetaJSON "${!output}"
    done
}
