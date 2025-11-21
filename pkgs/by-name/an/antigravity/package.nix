{
  lib,
  stdenv,
  callPackage,
  vscode-generic,
  fetchurl,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:

let
  inherit (stdenv) hostPlatform;

  sources =
    (lib.importJSON ./sources.json)."${hostPlatform.system}"
      or (throw "antigravity: unsupported system ${hostPlatform.system}");

  version = "1.11.3";
  vscodeVersion = "1.104.0";
in
callPackage vscode-generic {
  inherit
    commandLineArgs
    useVSCodeRipgrep
    version
    vscodeVersion
    ;

  pname = "antigravity";

  executableName = "antigravity";
  longName = "Google Antigravity";
  shortName = "Antigravity";
  libraryName = "antigravity";
  iconName = "antigravity";

  src = fetchurl {
    inherit (sources) url hash;
  };

  sourceRoot = if hostPlatform.isDarwin then "Antigravity.app" else "Antigravity";

  tests = { };
  updateScript = ./update.sh;

  dontFixup = hostPlatform.isDarwin;

  meta = {
    mainProgram = "antigravity";
    description = "Agentic development platform, evolving the IDE into the agent-first era";
    homepage = "https://antigravity.google";
    downloadPage = "https://antigravity.google/download";
    changelog = "https://antigravity.google/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      Zaczero
    ];
  };
}
