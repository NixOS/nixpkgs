{ lib, stdenv
, sway-unwrapped, swaybg
, makeWrapper, symlinkJoin, writeShellScriptBin
, withBaseWrapper ? true, extraSessionCommands ? "", dbus
, withGtkWrapper ? false, wrapGAppsHook, gdk-pixbuf
, extraOptions ? [] # E.g.: [ "--verbose" ]
}:

assert extraSessionCommands != "" -> withBaseWrapper;

with lib;

let
  baseWrapper = writeShellScriptBin "sway" ''
     set -o errexit
     if [ ! "$_SWAY_WRAPPER_ALREADY_EXECUTED" ]; then
       export _SWAY_WRAPPER_ALREADY_EXECUTED=1
       ${extraSessionCommands}
     fi
     if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
       export DBUS_SESSION_BUS_ADDRESS
       exec ${sway-unwrapped}/bin/sway "$@"
     else
       exec ${dbus}/bin/dbus-run-session ${sway-unwrapped}/bin/sway "$@"
     fi
   '';
in symlinkJoin {
  name = "sway-${sway-unwrapped.version}";

  paths = (optional withBaseWrapper baseWrapper)
    ++ [ sway-unwrapped ];

  nativeBuildInputs = [ makeWrapper ]
    ++ (optional withGtkWrapper wrapGAppsHook);

  buildInputs = optional withGtkWrapper gdk-pixbuf;

  postBuild = ''
    # We want to run wrapProgram manually to only wrap sway and add swaybg:
    export dontWrapGApps=true
    ${optionalString withGtkWrapper "wrapGAppsHook"}
    wrapProgram $out/bin/sway \
      --prefix PATH : "${swaybg}/bin" \
      ${optionalString withGtkWrapper ''"''${gappsWrapperArgs[@]}"''} \
      ${optionalString (extraOptions != []) "${concatMapStrings (x: " --add-flags " + x) extraOptions}"}
  '';

  passthru.providedSessions = [ "sway" ];

  inherit (sway-unwrapped) meta;
}
