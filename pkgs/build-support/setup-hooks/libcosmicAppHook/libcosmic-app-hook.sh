# shellcheck shell=bash
libcosmicAppWrapperArgs=()

libcosmicAppVergenHook() {
  export VERGEN_GIT_COMMIT_DATE="$SOURCE_DATE_EPOCH"
}

libcosmicAppLinkerArgsHook() {
  # Force linking to certain libraries like libEGL, which are always dlopen()ed
  local flags="CARGO_TARGET_@cargoLinkerVar@_RUSTFLAGS"

  export "$flags"="${!flags-} -C link-arg=-Wl,--push-state,--no-as-needed"
  # shellcheck disable=SC2043
  for lib in @cargoLinkLibs@; do
      export "$flags"="${!flags} -C link-arg=-l${lib}"
  done
  export "$flags"="${!flags} -C link-arg=-Wl,--pop-state"
}

preConfigurePhases+=" libcosmicAppVergenHook libcosmicAppLinkerArgsHook"

libcosmicAppWrapperArgsHook() {
    if [ -d "${prefix:?}/share" ]; then
        libcosmicAppWrapperArgs+=(--suffix XDG_DATA_DIRS : "$prefix/share")
    fi

    # add fallback schemas, icons, and settings paths
    libcosmicAppWrapperArgs+=(--suffix XDG_DATA_DIRS : "@fallbackXdgDirs@")
}

preFixupPhases+=" libcosmicAppWrapperArgsHook"

wrapLibcosmicApp() {
    local program="$1"
    shift 1
    wrapProgram "$program" "${libcosmicAppWrapperArgs[@]}" "$@"
}

# Note: $libcosmicAppWrapperArgs still gets defined even if ${dontWrapLibcosmicApp-} is set
libcosmicAppWrapHook() {
    # guard against running multiple times (e.g. due to propagation)
    [ -z "$libcosmicAppWrapHookHasRun" ] || return 0
    libcosmicAppWrapHookHasRun=1

    if [[ -z "${dontWrapLibcosmicApp:-}" ]]; then
        targetDirsThatExist=()
        targetDirsRealPath=()

        # wrap binaries
        targetDirs=("${prefix}/bin" "${prefix}/libexec")
        for targetDir in "${targetDirs[@]}"; do
            if [[ -d "${targetDir}" ]]; then
                targetDirsThatExist+=("${targetDir}")
                targetDirsRealPath+=("$(realpath "${targetDir}")/")
                find "${targetDir}" -type f -executable -print0 |
                    while IFS= read -r -d '' file; do
                        echo "Wrapping program '${file}'"
                        wrapLibcosmicApp "${file}"
                    done
            fi
        done

        # wrap links to binaries that point outside targetDirs
        # Note: links to binaries within targetDirs do not need
        #       to be wrapped as the binaries have already been wrapped
        if [[ ${#targetDirsThatExist[@]} -ne 0 ]]; then
            find "${targetDirsThatExist[@]}" -type l -xtype f -executable -print0 |
                while IFS= read -r -d '' linkPath; do
                    linkPathReal=$(realpath "${linkPath}")
                    for targetPath in "${targetDirsRealPath[@]}"; do
                        if [[ "$linkPathReal" == "$targetPath"* ]]; then
                            echo "Not wrapping link: '$linkPath' (already wrapped)"
                            continue 2
                        fi
                    done
                    echo "Wrapping link: '$linkPath'"
                    wrapLibcosmicApp "${linkPath}"
                done
        fi
    fi
}

fixupOutputHooks+=(libcosmicAppWrapHook)
