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
<<<<<<< HEAD
  sway = sway-unwrapped.overrideAttrs (oa: { inherit isNixOS enableXWayland; });
=======
  sway = sway-unwrapped.override { inherit isNixOS enableXWayland; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  baseWrapper = writeShellScriptBin "sway" ''
     set -o errexit
     if [ ! "$_SWAY_WRAPPER_ALREADY_EXECUTED" ]; then
       export XDG_CURRENT_DESKTOP=sway
       ${extraSessionCommands}
       export _SWAY_WRAPPER_ALREADY_EXECUTED=1
     fi
     if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
       export DBUS_SESSION_BUS_ADDRESS
       exec ${sway}/bin/sway "$@"
     else
<<<<<<< HEAD
       exec ${lib.optionalString dbusSupport "${dbus}/bin/dbus-run-session"} ${sway}/bin/sway "$@"
=======
       exec ${if !dbusSupport then "" else "${dbus}/bin/dbus-run-session"} ${sway}/bin/sway "$@"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
     fi
   '';
in symlinkJoin {
  name = "sway-${sway.version}";

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

    wrapProgram $out/bin/sway \
      ${optionalString withGtkWrapper ''"''${gappsWrapperArgs[@]}"''} \
      ${optionalString (extraOptions != []) "${concatMapStrings (x: " --add-flags " + x) extraOptions}"}
  '';

  passthru = {
    inherit (sway.passthru) tests;
    providedSessions = [ "sway" ];
  };

  inherit (sway) meta;
}
