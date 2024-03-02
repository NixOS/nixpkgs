{ lib
, sway-unwrapped
, makeWrapper, symlinkJoin, writeShellScriptBin
, withBaseWrapper ? true, extraSessionCommands ? "", dbus
, withGtkWrapper ? false, wrapGAppsHook, gdk-pixbuf, glib, gtk3
, extraOptions ? [] # E.g.: [ "--verbose" ]
# Used by the NixOS module:
, isNixOS ? false

, enableXWayland ? true
, dbusSupport ? true
}:

assert extraSessionCommands != "" -> withBaseWrapper;

with lib;

let
  sway = sway-unwrapped.overrideAttrs (oa: { inherit isNixOS enableXWayland; });
  baseWrapper = writeShellScriptBin sway.meta.mainProgram ''
     set -o errexit
     if [ ! "$_SWAY_WRAPPER_ALREADY_EXECUTED" ]; then
       export XDG_CURRENT_DESKTOP=${sway.meta.mainProgram}
       ${extraSessionCommands}
       export _SWAY_WRAPPER_ALREADY_EXECUTED=1
     fi
     if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
       export DBUS_SESSION_BUS_ADDRESS
       exec ${lib.getExe sway} "$@"
     else
       exec ${lib.optionalString dbusSupport "${dbus}/bin/dbus-run-session"} ${lib.getExe sway} "$@"
     fi
   '';
in symlinkJoin rec {
  pname = lib.replaceStrings ["-unwrapped"] [""] sway.pname;
  inherit (sway) version;
  name = "${pname}-${version}";

  paths = (optional withBaseWrapper baseWrapper)
    ++ [ sway ];

  strictDeps = false;
  nativeBuildInputs = [ makeWrapper ]
    ++ (optional withGtkWrapper wrapGAppsHook);

  buildInputs = optionals withGtkWrapper [ gdk-pixbuf glib gtk3 ];

  # We want to run wrapProgram manually
  dontWrapGApps = true;

  postBuild = ''
    ${optionalString withGtkWrapper "gappsWrapperArgsHook"}

    wrapProgram $out/bin/${sway.meta.mainProgram} \
      ${optionalString withGtkWrapper ''"''${gappsWrapperArgs[@]}"''} \
      ${optionalString (extraOptions != []) "${concatMapStrings (x: " --add-flags " + x) extraOptions}"}
  '';

  passthru = {
    inherit (sway.passthru) tests;
    providedSessions = [ sway.meta.mainProgram ];
  };

  inherit (sway) meta;
}
