{ lib
, stdenvNoCC }:

let
  escapedList = with lib; concatMapStringsSep " " (s: "'${escape [ "'" ] s}'");
  fileName = pathStr: lib.last (lib.splitString "/" pathStr);
  scriptsDir = "$out/share/mpv/scripts";
in
lib.makeOverridable (
  { pname
  , scriptPath ? "${pname}.lua"
  , extraScripts ? []
  , ... }@args:

  stdenvNoCC.mkDerivation (lib.attrsets.recursiveUpdate {
    dontBuild = true;
    preferLocalBuild = true;

    outputHashMode = "recursive";
    installPhase = ''
      runHook preInstall
      install -m644 -Dt "${scriptsDir}" \
        ${escapedList ([ scriptPath ] ++ extraScripts)}
      runHook postInstall
    '';

    passthru.scriptName = fileName scriptPath;
    meta.platforms = lib.platforms.all;
  } args)
)
