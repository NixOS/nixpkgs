{ lib
, stdenvNoCC }:

let
  escapedList = with lib; concatMapStringsSep " " (s: "'${escape [ "'" ] s}'");
  fileName = pathStr: lib.last (lib.splitString "/" pathStr);
  scriptsDir = "$out/share/mpv/scripts";
in
lib.makeOverridable (
  { pname
  , extraScripts ? []
  , ... }@args:
  let
    # either passthru.scriptName, inferred from scriptPath, or from pname
    scriptName = (args.passthru or {}).scriptName or (
      if args ? scriptPath
      then fileName args.scriptPath
      else "${pname}.lua"
    );
    scriptPath = args.scriptPath or "./${scriptName}";
  in
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

    passthru = { inherit scriptName; };
    meta.platforms = lib.platforms.all;
  } args)
)
