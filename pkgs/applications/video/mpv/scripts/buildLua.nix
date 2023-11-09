{ lib
, stdenvNoCC }:

let fileName = pathStr: lib.last (lib.splitString "/" pathStr);
in
lib.makeOverridable (
  { pname, scriptPath ? "${pname}.lua", ... }@args:
  stdenvNoCC.mkDerivation (lib.attrsets.recursiveUpdate {
    dontBuild = true;
    preferLocalBuild = true;

    outputHashMode = "recursive";
    installPhase = ''
      runHook preInstall
      install -m644 -Dt $out/share/mpv/scripts ${scriptPath}
      runHook postInstall
    '';

    passthru.scriptName = fileName scriptPath;
    meta.platforms = lib.platforms.all;
  } args)
)
