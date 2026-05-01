{
  lib,
  stdenv,
  buildVscode,
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
      loongarch64-linux = "linux-loong64";
    }
    .${system} or throwSystem;

  archive_fmt = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";

  hash =
    {
      x86_64-linux = "sha256-CP4tIZhDoC56T6N0RUebNRw3CjxG82odHt4WY8rgmS8=";
      x86_64-darwin = "sha256-4EWKIXc+CKQLot7eN6Bkd/xigByEGafLMKJ832EOSwA=";
      aarch64-linux = "sha256-5EwENP1lpHzqiWWeXNQzQOp/zAAEanSbDhWcMeup2sY=";
      aarch64-darwin = "sha256-9n7kVtknqfSfTc2MmFps5bxSqMnL6KNhZgTb+DVUkhY=";
      armv7l-linux = "sha256-aXGqp7ljvqDJNb5BMiBIm2CluIr70oiNPmR7BULLsv8=";
      loongarch64-linux = "sha256-XPEssw+7NVKljyrWcc+Q2HzRr31seDwbdNn3EtyHlSY=";
    }
    .${system} or throwSystem;

  sourceRoot = lib.optionalString (!stdenv.hostPlatform.isDarwin) ".";
in
buildVscode rec {
  inherit sourceRoot commandLineArgs useVSCodeRipgrep;

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.112.01907";
  pname = "vscodium";

  executableName = "codium";
  longName = "VSCodium";
  shortName = "vscodium";

  src = fetchurl {
    url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
    inherit hash;
  };

  tests = nixosTests.vscodium.xorg;

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
      bobby285271
    ];
    mainProgram = "codium";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
      "loongarch64-linux"
    ];
    # requires libc.so.6 and other glibc specifics
    broken = stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isGnu;
  };
}
