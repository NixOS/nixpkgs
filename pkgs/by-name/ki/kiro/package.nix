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
  inherit (stdenv) hostPlatform;
  version = "0.1.0";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://prod.download.desktop.kiro.dev/releases/202507140012--distro-linux-x64-tar-gz/202507140012-distro-linux-x64.tar.gz";
      hash = "sha256-6bbc/HndiN/HUoZyYo9r6Olih2n4/NMyRpxD59z9SH0=";
    };
  };
  src = sources.${hostPlatform.system} or (throw "Unsupported platform for Kiro");
in
(callPackage vscode-generic {
  inherit useVSCodeRipgrep;
  commandLineArgs = extraCommandLineArgs;

  inherit version;
  pname = "kiro";

  # You can find the current VSCode version in the About dialog:
  # workbench.action.showAboutDialog (Help: About)
  vscodeVersion = "1.94.0";

  executableName = "kiro";
  longName = "Kiro";
  shortName = "kiro";
  libraryName = "kiro";
  iconName = "kiro";

  inherit src;
  sourceRoot = "Kiro";
  patchVSCodePath = true;

  tests = { };
  updateScript = null;

  meta = {
    description = "IDE for Agentic AI workflows based on VS Code";
    homepage = "https://kiro.dev";
    license = lib.licenses.amazonsl;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ vuks ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "kiro";
  };

}).overrideAttrs
  (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      inherit sources;
    };
  })
