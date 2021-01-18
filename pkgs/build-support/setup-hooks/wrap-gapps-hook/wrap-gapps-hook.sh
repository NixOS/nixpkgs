# shellcheck shell=bash
appsWrapperArgs=()
gappsWrapperArgs=()

# Inherit arguments given in mkDerivation
gappsWrapperArgs=( ${gappsWrapperArgs-} )

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

    # Extend the appsWrapperArgs for wrapAppsHook
    appsWrapperArgs+=gappsWrapperArgs
}

preFixupPhases+=" gappsWrapperArgsHook"
