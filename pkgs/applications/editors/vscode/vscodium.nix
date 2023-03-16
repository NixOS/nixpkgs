{ lib, stdenv, callPackage, fetchurl, nixosTests, commandLineArgs ? "" }:

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
    x86_64-linux = "1cwxb6713hlgbrp4yhaky18r05ykb2ljxkldpj3hlgiz8x9l3n8r";
    x86_64-darwin = "14j7jsy7ldgkjpfb6acyv86nqfg6mip27rq0d9zfg26n4m0qm3s9";
    aarch64-linux = "080qqc9bacgs655sz32vdczdlkylycgzf5l584il9xyn7bp8xyk1";
    aarch64-darwin = "0ifzwjalwskxm4phf9c4v6sfyxhdh63vzdippcwh0r7fx0gcj6g8";
    armv7l-linux = "1gchynk0i05jkan47773fdlkbppwvdim73qwpcxbl0ck2giy7q9z";
  }.${system} or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in
  callPackage ./generic.nix rec {
    inherit sourceRoot commandLineArgs;

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.76.2.23074";
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
      maintainers = with maintainers; [ synthetica turion bobby285271 ];
      mainProgram = "codium";
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" "armv7l-linux" ];
    };
  }
