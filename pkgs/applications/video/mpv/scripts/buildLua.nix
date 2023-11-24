{ lib
, stdenvNoCC }:

let
  inherit (lib) hasPrefix hasSuffix removeSuffix;
  escapedList = with lib; concatMapStringsSep " " (s: "'${escape [ "'" ] s}'");
  fileName = pathStr: lib.last (lib.splitString "/" pathStr);
  nameFromPath = pathStr:
    let fN = fileName pathStr; in
    if hasSuffix ".lua" fN then
      fN
    else if !(hasPrefix "." fN) then
      "${fN}.lua"
    else
      null
  ;
  scriptsDir = "$out/share/mpv/scripts";
in
lib.makeOverridable (
  { pname
  , extraScripts ? []
  , ... }@args:
  let
    # either passthru.scriptName, inferred from scriptPath, or from pname
    scriptName = (args.passthru or {}).scriptName or (
      if args ? scriptPath && nameFromPath args.scriptPath != null
      then nameFromPath args.scriptPath
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

      if [ -d "${scriptPath}" ]; then
        [ -f "${scriptPath}/main.lua" ] || {
          echo "Script directory '${scriptPath}' does not contain 'main.lua'" >&2
          exit 1
        }
        [ ${with builtins; toString (length extraScripts)} -eq 0 ] || {
          echo "mpvScripts.buildLua does not support 'extraScripts'" \
               "when 'scriptPath' is a directory"
          exit 1
        }
        mkdir -p "${scriptsDir}"
        cp -a "${scriptPath}" "${scriptsDir}/${lib.removeSuffix ".lua" scriptName}"
      else
        install -m644 -Dt "${scriptsDir}" \
          ${escapedList ([ scriptPath ] ++ extraScripts)}
      fi

      runHook postInstall
    '';

    passthru = { inherit scriptName; };
    meta.platforms = lib.platforms.all;
  } args)
)
