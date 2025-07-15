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
  version = "0.1.25";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://prod.download.desktop.kiro.dev/releases/202507232027--distro-linux-x64-tar-gz/202507232027-distro-linux-x64.tar.gz";
      hash = "sha256-XxtJS7hLUKHJG0HhiA2Fyt7wNh5YebOOYadvNvXCKzc=";
    };
    x86_64-darwin = fetchurl {
      url = "https://prod.download.desktop.kiro.dev/releases/202507232041-Kiro-dmg-darwin-x64.dmg";
      hash = "sha256-dH+aQ8IKqGC0TLMlOQFk7UYhL5/dWSOwLXD417bBpWk=";
    };
    aarch64-darwin = fetchurl {
      url = "https://prod.download.desktop.kiro.dev/releases/202507232015-Kiro-dmg-darwin-arm64.dmg";
      hash = "sha256-GQ40ZirD+MEHcS6B7i7xl0wYCPspvokRrMuD3eqZQM4=";
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
