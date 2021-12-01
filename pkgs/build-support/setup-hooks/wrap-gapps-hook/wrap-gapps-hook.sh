# shellcheck shell=bash
gappsWrapperArgs=()

find_gio_modules() {
    if [ -d "$1/lib/gio/modules" ] && [ -n "$(ls -A "$1/lib/gio/modules")" ] ; then
        gappsWrapperArgs+=(--prefix GIO_EXTRA_MODULES : "$1/lib/gio/modules")
    fi
}

addEnvHooks "${targetOffset:?}" find_gio_modules

gappsWrapperArgsHook() {
    if [ -n "$GDK_PIXBUF_MODULE_FILE" ]; then
        gappsWrapperArgs+=(--set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE")
    fi

    if [ -n "$XDG_ICON_DIRS" ]; then
        gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS")
    fi

    if [ -n "$GSETTINGS_SCHEMAS_PATH" ]; then
        gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH")
    fi

    # Check for prefix as well
    if [ -d "${prefix:?}/share" ]; then
        gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$prefix/share")
    fi

    if [ -d "$prefix/lib/gio/modules" ] && [ -n "$(ls -A "$prefix/lib/gio/modules")" ]; then
        gappsWrapperArgs+=(--prefix GIO_EXTRA_MODULES : "$prefix/lib/gio/modules")
    fi

    for v in ${wrapPrefixVariables:-} GST_PLUGIN_SYSTEM_PATH_1_0 GI_TYPELIB_PATH GRL_PLUGIN_PATH; do
        if [ -n "${!v}" ]; then
            gappsWrapperArgs+=(--prefix "$v" : "${!v}")
        fi
    done
}

preFixupPhases+=" gappsWrapperArgsHook"

wrapGApp() {
    local program="$1"
    shift 1
    wrapProgram "$program" "${gappsWrapperArgs[@]}" "$@"
}

# Note: $gappsWrapperArgs still gets defined even if ${dontWrapGApps-} is set.
wrapGAppsHook() {
    # guard against running multiple times (e.g. due to propagation)
    [ -z "$wrapGAppsHookHasRun" ] || return 0
    wrapGAppsHookHasRun=1

    if [[ -z "${dontWrapGApps:-}" ]]; then
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
                        wrapGApp "${file}"
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
                    wrapGApp "${linkPath}"
                done
        fi
    fi
}

fixupOutputHooks+=(wrapGAppsHook)
