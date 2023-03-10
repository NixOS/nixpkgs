{ lib
, stdenv
# The unwrapped libreoffice derivation
, unwrapped
, makeWrapper
, runCommand
, substituteAll
# For Emulating wrapGAppsHook
, gsettings-desktop-schemas
, hicolor-icon-theme
, dconf
, librsvg
, gdk-pixbuf
# Configuration options for the wrapper
, extraMakeWrapperArgs ? []
, dbusVerify ? stdenv.isLinux
, dbus
}:

let
  makeWrapperArgs = builtins.concatStringsSep " " ([
    "--set" "GDK_PIXBUF_MODULE_FILE" "${librsvg}/${gdk-pixbuf.moduleDir}.cache"
    "--prefix" "GIO_EXTRA_MODULES" ":" "${lib.getLib dconf}/lib/gio/modules"
    "--prefix" "XDG_DATA_DIRS" ":" "${unwrapped.gtk3}/share/gsettings-schemas/${unwrapped.gtk3.name}"
    "--prefix" "XDG_DATA_DIRS" ":" "$out/share"
    "--prefix" "XDG_DATA_DIRS" ":" "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
    "--prefix" "XDG_DATA_DIRS" ":" "${hicolor-icon-theme}/share"
    "--prefix" "GST_PLUGIN_SYSTEM_PATH_1_0" ":"
      "${lib.makeSearchPath "lib/girepository-1.0" unwrapped.gst_packages}"
  ] ++ lib.optionals unwrapped.kdeIntegration [
    "--prefix" "QT_PLUGIN_PATH" ":" "${
      lib.makeSearchPath
      unwrapped.qtbase.qtPluginPrefix
      (builtins.map lib.getBin unwrapped.qtPackages)
    }"
    "--prefix" "QML2_IMPORT_PATH" ":" "${
      lib.makeSearchPath unwrapped.qtbase.qtQmlPrefix
      (builtins.map lib.getBin unwrapped.qmlPackages)
    }"
  ] ++ [
    # Add dictionaries from all NIX_PROFILES
    "--run" (lib.escapeShellArg ''
      for PROFILE in $NIX_PROFILES; do
          HDIR="$PROFILE/share/hunspell"
          if [ -d "$HDIR" ]; then
              export DICPATH=$DICPATH''${DICPATH:+:}$HDIR
          fi
      done
    '')
  ] ++ lib.optionals dbusVerify [
    # If no dbus is running, start a dedicated dbus daemon
    "--run" (lib.escapeShellArg ''
      if ! ( test -n "$DBUS_SESSION_BUS_ADDRESS" ); then
          dbus_tmp_dir="/run/user/$(id -u)/libreoffice-dbus"
          if ! test -d "$dbus_tmp_dir" && test -d "/run"; then
                  mkdir -p "$dbus_tmp_dir"
          fi
          if ! test -d "$dbus_tmp_dir"; then
                  dbus_tmp_dir="/tmp/libreoffice-$(id -u)/libreoffice-dbus"
                  mkdir -p "$dbus_tmp_dir"
          fi
          dbus_socket_dir="$(mktemp -d -p "$dbus_tmp_dir")"
          "${dbus}"/bin/dbus-daemon \
            --nopidfile \
            --nofork \
            --config-file "${dbus}"/share/dbus-1/session.conf \
            --address "unix:path=$dbus_socket_dir/session"  &> /dev/null &
          dbus_pid=$!
          export DBUS_SESSION_BUS_ADDRESS="unix:path=$dbus_socket_dir/session"
      fi
    '')
  ] ++ [
    "--chdir" "${unwrapped}/lib/libreoffice/program"
    "--inherit-argv0"
  ] ++ extraMakeWrapperArgs
  );
in runCommand "${unwrapped.name}-wrapped" {
  inherit (unwrapped) meta;
  paths = [ unwrapped ];
  nativeBuildInputs = [ makeWrapper ];
  passthru = {
    inherit unwrapped;
    # For backwards compatibility:
    libreoffice = lib.warn "libreoffice: Use the unwrapped attributed, using libreoffice.libreoffice is deprecated." unwrapped;
    inherit (unwrapped) kdeIntegration;
  };
} (''
  mkdir -p "$out/bin"
  ln -s ${unwrapped}/share $out/share
  ln -s ${unwrapped}/lib $out/lib
  for i in sbase scalc sdraw smath swriter simpress soffice unopkg; do
    makeWrapper ${unwrapped}/lib/libreoffice/program/$i $out/bin/$i ${makeWrapperArgs}
'' + lib.optionalString dbusVerify ''
    # Delete the dbus socket directory after libreoffice quits
    sed -i 's/^exec -a "$0" //g' $out/bin/"$i"
    echo 'code="$?"' >> $out/bin/$i
    echo 'test -n "$dbus_socket_dir" && { rm -rf "$dbus_socket_dir"; kill $dbus_pid; }' >> $out/bin/$i
    echo 'exit "$code"' >> $out/bin/$i
'' + ''
  done
'')
