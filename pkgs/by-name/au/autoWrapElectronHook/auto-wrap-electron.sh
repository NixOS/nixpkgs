# shellcheck shell=bash
set -eEuo pipefail

pruneElectronFiles() {
    local ignoreArray ignoreString
    concatTo ignoreArray autoWrapElectronIgnore

    # Concat the ignore array to a string for
    # easier formatting
    if [[ "${#ignoreArray[@]}" -gt 0 ]]; then
      ignoreString="--ignore ${ignoreArray[*]}"
    fi

    # The rust program
    prune-electron                      \
        --electron "@ELECTRON_PACKAGE@" \
        ${symlinkElectron:+--symlink}   \
        ${ignoreString-}                \
        "$@"
}

electronWrap() {
  local electronWrapperArgsArray asarToWrap findResult cmdProgram

  concatTo electronWrapperArgsArray electronWrapperArgs

  if [[ -n "${electronAppAsar-}" ]]; then
    # Use the user input
    asarToWrap="$electronAppAsar"
  else
    # Look for files named "app.asar", output results as null-terminated string, and store each string to an array
    mapfile -t -d $'\0' findResult < <(find "${!outputBin:?}" -type f -a -name "app.asar" -print0)

    # Ensure only one is found
    if [[ ${#findResult[@]} -eq 0 ]]; then
      echo "Did not find 'app.asar' in the bin output. Please supply the path to it with 'electronAppAsar'"
      exit 2
    elif [[ ${#findResult[@]} -gt 1 ]]; then
      printf "Found multiple 'app.asar' files:\n%s\nPlease supply the path to wrap with 'electronAppAsar'" "${findResult[*]}"
      exit 2
    else
      asarToWrap="${findResult[0]}"
    fi
  fi

  # Check that mainProgram is set
  if [[ -n "${autoWrapElectronOutput-}" ]]; then
    # User input
    cmdProgram="${autoWrapElectronOutput-}"
  elif [[ -n "${NIX_MAIN_PROGRAM-}" ]]; then
    # meta.mainProgram
    cmdProgram="${NIX_MAIN_PROGRAM-}"
  else
    echo "autoWrapElectronHook: \$mainProgram is not set so we don't know how to set the binary name." \
         "  To fix this set \`mainProgram\` or \`autoWrapElectronOutput\`"
    exit 2
  fi

  mkdir -p "${!outputBin}/bin"
  makeWrapper "@ELECTRON_PACKAGE@/bin/electron" "${!outputBin}/bin/${cmdProgram}" \
    --add-flags "$asarToWrap"                  \
    "${electronWrapperArgsArray[@]}"

  echo "autoWrapElectronHook: Electron wrapper running '$asarToWrap' placed in '${!outputBin}/bin/$cmdProgram'"
}

autoWrapElectronFixup() {
    echo "autoWrapElectronHook: Starting..."

    if [[ -z "${dontPruneElectronFiles-}" ]]; then
        pruneElectronFiles -- "$(for output in $(getAllOutputNames); do
            [ -e "${!output}" ] || continue
            [ "${output}" = debug ] && continue
            echo "${!output}"
        done)"
    fi

    electronWrap

    echo "autoWrapElectronHook: Done"
}

fixupOutputHooks+=(autoWrapElectronFixup)
