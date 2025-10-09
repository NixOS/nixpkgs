{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux-x64";
      x86_64-darwin = "darwin-x64";
      aarch64-linux = "linux-arm64";
      aarch64-darwin = "darwin-arm64";
      armv7l-linux = "linux-armhf";
    }
    .${system} or throwSystem;

  archive_fmt = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";

  hash =
    {
      x86_64-linux = "sha256-OWJqNm08Uy7Wr5pbucS0eWUyN3xU6/qLYM8wL/hg2dY=";
      x86_64-darwin = "sha256-Cq+JfzSTYJ85OWW9QjDSGU6yBqvoEniaqlwA/eT/+c0=";
      aarch64-linux = "sha256-u5IRp1qoPN2A5T9iPDPrZjhw/UAHcBrRanWPJMeFD0k=";
      aarch64-darwin = "sha256-KDqNpsLi+EXoAAY0TZFkbHT8WBy1f4hU1ag7Fp24MKY=";
      armv7l-linux = "sha256-9R4FBxyIx7+jMNrUDfMrvIMNqggJ97mTSTXIjG5ccLI=";
    }
    .${system} or throwSystem;

  sourceRoot = lib.optionalString (!stdenv.hostPlatform.isDarwin) ".";
in
callPackage ./generic.nix rec {
  inherit sourceRoot commandLineArgs useVSCodeRipgrep;

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.104.36664";
  pname = "vscodium";

  executableName = "codium";
  longName = "VSCodium";
  shortName = "vscodium";

  src = fetchurl {
    url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
    inherit hash;
  };

  tests = nixosTests.vscodium;

  updateScript = ./update-vscodium.sh;

  # Editing the `codium` binary (and shell scripts) within the app bundle causes the bundle's signature
  # to be invalidated, which prevents launching starting with macOS Ventura, because VSCodium is notarized.
  # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
  dontFixup = stdenv.hostPlatform.isDarwin;

  meta = {
    description = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS (VS Code without MS branding/telemetry/licensing)
    '';
    longDescription = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS. It includes support for debugging, embedded Git
      control, syntax highlighting, intelligent code completion, snippets,
      and code refactoring. It is also customizable, so users can change the
      editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://github.com/VSCodium/vscodium";
    downloadPage = "https://github.com/VSCodium/vscodium/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      synthetica
      bobby285271
    ];
    mainProgram = "codium";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
    ];
    # requires libc.so.6 and other glibc specifics
    broken = stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isGnu;
  };
}
