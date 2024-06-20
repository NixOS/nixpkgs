{ lib, stdenv, callPackage, fetchurl, nixosTests, commandLineArgs ? "", useVSCodeRipgrep ? stdenv.isDarwin }:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "1r76ikfikagg9v278pgiqhnjsv7pqn0xi372y1l0wsashlxl7kb0";
    x86_64-darwin = "156604xzazmb54p0rdkv5wy9livg0xz2jviycdizablmvsxybs57";
    aarch64-linux = "0cp120pcjpgf9qvmks9f8l2caxqlvnqvmxa7fh9mf83zpkdmnsnl";
    aarch64-darwin = "1k06648jx64irshs0v4qy6xlkd9mk514xf21dlfhvic4aj89kcx9";
    armv7l-linux = "0jy8hkbxh1969kskggg2y86cphly9l9gs7y4plj90jmlvlzjjjxm";
  }.${system} or throwSystem;

  sourceRoot = lib.optionalString (!stdenv.isDarwin) ".";
in
  callPackage ./generic.nix rec {
    inherit sourceRoot commandLineArgs useVSCodeRipgrep;

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.90.1.24165";
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
      maintainers = with maintainers; [ synthetica bobby285271 ludovicopiero ];
      mainProgram = "codium";
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" "armv7l-linux" ];
    };
  }
