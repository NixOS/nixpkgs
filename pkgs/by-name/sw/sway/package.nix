{ lib
, sway-unwrapped
, makeWrapper, symlinkJoin, writeShellScriptBin
, withBaseWrapper ? true, extraSessionCommands ? "", dbus
, withGtkWrapper ? false, wrapGAppsHook3, gdk-pixbuf, glib, gtk3
, extraOptions ? [] # E.g.: [ "--verbose" ]
# Used by the NixOS module:
, isNixOS ? false

, enableXWayland ? true
, dbusSupport ? true
}:

assert extraSessionCommands != "" -> withBaseWrapper;

let
  inherit (builtins) replaceStrings;
  inherit (lib.lists) optional optionals;
  inherit (lib.meta) getExe;
  inherit (lib.strings) concatMapStrings optionalString;

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
       exec ${getExe sway} "$@"
     else
       exec ${optionalString dbusSupport "${dbus}/bin/dbus-run-session"} ${getExe sway} "$@"
     fi
   '';
in symlinkJoin rec {
  pname = replaceStrings ["-unwrapped"] [""] sway.pname;
  inherit (sway) version;
  name = "${pname}-${version}";

  paths = (optional withBaseWrapper baseWrapper)
    ++ [ sway ];

  strictDeps = false;
  nativeBuildInputs = [ makeWrapper ]
    ++ (optional withGtkWrapper wrapGAppsHook3);

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
