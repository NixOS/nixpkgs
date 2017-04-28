gappsWrapperArgs=()

find_gio_modules() {
    if [ -d "$1"/lib/gio/modules ] && [ -n "$(ls -A $1/lib/gio/modules)" ] ; then
        gappsWrapperArgs+=(--prefix GIO_EXTRA_MODULES : "$1/lib/gio/modules")
    fi
}

envHooks+=(find_gio_modules)

# Note: $gappsWrapperArgs still gets defined even if $dontWrapGApps is set.
wrapGAppsHook() {
  # guard against running multiple times (e.g. due to propagation)
  [ -z "$wrapGAppsHookHasRun" ] || return 0
  wrapGAppsHookHasRun=1

  if [ -n "$GDK_PIXBUF_MODULE_FILE" ]; then
    gappsWrapperArgs+=(--set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE")
  fi

  if [ -n "$XDG_ICON_DIRS" ]; then
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS")
  fi

  if [ -n "$GSETTINGS_SCHEMAS_PATH" ]; then
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH")
  fi

  if [ -d "$prefix/share" ]; then
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$prefix/share")
  fi

  for v in $wrapPrefixVariables GST_PLUGIN_SYSTEM_PATH_1_0 GI_TYPELIB_PATH GRL_PLUGIN_PATH; do
    eval local dummy="\$$v"
    gappsWrapperArgs+=(--prefix $v : "$dummy")
  done

  if [ -z "$dontWrapGApps" ]; then
    for i in $prefix/bin/* $prefix/libexec/*; do
      echo "Wrapping app $i"
      wrapProgram "$i" "${gappsWrapperArgs[@]}"
    done
  fi
}

fixupOutputHooks+=(wrapGAppsHook)
