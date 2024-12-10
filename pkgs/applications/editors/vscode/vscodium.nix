{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.isDarwin,
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

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 =
    {
      x86_64-linux = "0hq2w9rc54qy6234njx6xfh3m1p3d206lr22sdxxa3snnrh4vrs8";
      x86_64-darwin = "0knkn4i6vvszxqzsv9564bbassqgszr8bfa4l7hsqy25ki37k5ln";
      aarch64-linux = "1k9qvymc7yfq8ihlbx8676gsjyfhg41acc5p4lrw9ci0a3sqanz9";
      aarch64-darwin = "029sdf0h9fcviv6qdphzlgb1qhy24vj79h465mf559gdih21xlp4";
      armv7l-linux = "16lwgagg2i6mwqm3p2z97di571wgl2hj255pnxqhcz6x9vq26l8p";
    }
    .${system} or throwSystem;

  sourceRoot = lib.optionalString (!stdenv.isDarwin) ".";
in
callPackage ./generic.nix rec {
  inherit sourceRoot commandLineArgs useVSCodeRipgrep;

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  version = "1.94.1.24283";
  pname = "vscodium";

  executableName = "codium";
  longName = "VSCodium";
  shortName = "vscodium";

  src = fetchurl {
    url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
    inherit sha256;
  };

  tests = nixosTests.vscodium;

  updateScript = ./update-vscodium.sh;

  meta = with lib; {
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
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      synthetica
      bobby285271
      ludovicopiero
    ];
    mainProgram = "codium";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
    ];
  };
}
