{
  buildVscode,
  fetchurl,
  stdenv,
  lib,
  addSettings,
  isabelle,
  vscode_extension,
}:

let
  vscodium = buildVscode rec {
    version = "1.105.17075";
    vscodeVersion = "1.105.1";
    pname = "vscodium";

    executableName = "electron";
    longName = "VSCodium";
    shortName = "vscodium";

    src = fetchurl {
      url = "https://isabelle.in.tum.de/components/vscodium-${version}.tar.gz";
      hash = "sha256-sKMUOZP8C0kHcKtH5J4+JaBDAM1kL7DXn+sak6kE8fk=";
    };
    sourceRoot =
      "vscodium-${version}/${isabelle.platform}"
      + lib.optionalString stdenv.hostPlatform.isDarwin "/VSCodium.app";

    tests = { };
    commandLineArgs = "";
    useVSCodeRipgrep = stdenv.hostPlatform.isDarwin;
    patchVSCodePath = false;
    updateScript = null;
    hasVsceSign = false;
    installExecutable = false;

    dontFixup = stdenv.hostPlatform.isDarwin;

    appDir = "vscodium";

    meta = {
      maintainers = with lib.maintainers; [ sempiternal-aurora ];
      # Package vendors electron 37, which is EOL
      knownVulnerabilities = [
        "CVE-2026-70608: Sandboxed iframe can bypass the allow-popups restriction via the OpenURL navigation path"
        "CVE-2026-70604: Custom protocol with supportFetchAPI but not corsEnabled allows cross-origin reads"
      ];
    };
  };
in

addSettings vscodium (
  finalAttrs:
  if stdenv.hostPlatform.isDarwin then
    ''
      ISABELLE_VSCODE_VSIX="${vscode_extension.vsix}"
      ISABELLE_VSCODIUM_HOME="${finalAttrs.finalPackage}/Applications"
      ISABELLE_VSCODIUM_ELECTRON="$ISABELLE_VSCODIUM_HOME/VSCodium.app/Contents/MacOS/Electron"
      ISABELLE_VSCODIUM_RESOURCES="$ISABELLE_VSCODIUM_HOME/VSCodium.app/Contents/Resources"
    ''
  else
    ''
      ISABELLE_VSCODE_VSIX="${vscode_extension.vsix}"
      ISABELLE_VSCODIUM_HOME="${finalAttrs.finalPackage}/lib/vscode"
      ISABELLE_VSCODIUM_ELECTRON="$ISABELLE_VSCODIUM_HOME/electron"
      ISABELLE_VSCODIUM_RESOURCES="$ISABELLE_VSCODIUM_HOME/resources"
    ''
)
