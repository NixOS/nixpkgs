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
    x86_64-linux = "1qwgdvsqwkbfxf9xdxfxfmf10xcxgik4v6s5djggq130mqvrnv7x";
    x86_64-darwin = "12cn369yi652fvk6lha5y6nglms2zqmvqsjwklj3dl0ms9329jzq";
    aarch64-linux = "1fxmbz3qv027spgh6j075s00r69hff1m4fqvs9p2axb5m7ikdp16";
    aarch64-darwin = "0g5ylxcn41x8ajl7lv3h2fkx52pkgmkw95malgh8h1y3rvg73a4n";
    armv7l-linux = "0m1v24gg2dy79hgrz37gysgrazg8vkr1gkp52j6m6y76vi0l8249";
  }.${system} or throwSystem;

  sourceRoot = if stdenv.isDarwin then "" else ".";
in
  callPackage ./generic.nix rec {
    inherit sourceRoot commandLineArgs useVSCodeRipgrep;

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.79.2.23166";
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
