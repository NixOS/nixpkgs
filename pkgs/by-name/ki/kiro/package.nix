{
  lib,
  stdenv,
  callPackage,
  vscode-generic,
  fetchurl,
  extraCommandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:

let
  sources = (lib.importJSON ./sources.json).${stdenv.hostPlatform.system};
in
(callPackage vscode-generic {
  inherit useVSCodeRipgrep;
  commandLineArgs = extraCommandLineArgs;

  version = "0.2.38";
  pname = "kiro";

  # You can find the current VSCode version in the About dialog:
  # workbench.action.showAboutDialog (Help: About)
  vscodeVersion = "1.100.3";

  executableName = "kiro";
  longName = "Kiro";
  shortName = "kiro";
  libraryName = "kiro";
  iconName = "kiro";

  src = fetchurl {
    url = sources.url;
    hash = sources.hash;
  };
  sourceRoot = "Kiro";
  patchVSCodePath = true;

  tests = { };
  updateScript = ./update.sh;

  meta = {
    description = "IDE for Agentic AI workflows based on VS Code";
    homepage = "https://kiro.dev";
    license = lib.licenses.amazonsl;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ vuks ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "kiro";
  };

}).overrideAttrs
  (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      inherit sources;
    };
  })
