{
  lib,
  stdenv,
  buildVscode,
  fetchurl,
  extraCommandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
  _7zz,
}:

let
  sources = (lib.importJSON ./sources.json).${stdenv.hostPlatform.system};
in
(buildVscode {
  inherit useVSCodeRipgrep;
  commandLineArgs = extraCommandLineArgs;

  version = "1.3.11";
  pname = "kiro";

  # You can find the current VSCode version in the About dialog:
  # workbench.action.showAboutDialog (Help: About)
  vscodeVersion = "1.131.0";

  executableName = "kiro";
  longName = "Kiro";
  shortName = "kiro";
  libraryName = "kiro";
  iconName = "kiro";

  src = fetchurl {
    url = sources.url;
    hash = sources.hash;
  };

  # Kiro.dmg is APFS formatted, unpack with 7zz
  extraNativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ _7zz ];

  sourceRoot = if stdenv.hostPlatform.isDarwin then "Kiro.app" else "Kiro";

  sourceExecutableName = if stdenv.hostPlatform.isDarwin then "code" else "kiro";

  dontFixup = stdenv.hostPlatform.isDarwin;

  patchVSCodePath = true;

  tests = { };
  updateScript = ./update.sh;

  meta = {
    description = "IDE for Agentic AI workflows based on VS Code";
    homepage = "https://kiro.dev";
    license = lib.licenses.amazonsl;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      vuks
      jamesward
    ];
    platforms = [
      "x86_64-linux"
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
