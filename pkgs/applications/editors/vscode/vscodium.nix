{ lib, stdenv, callPackage, fetchurl, nixosTests }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system};

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "1ns4cpkihbrwgh8pvn1kjlnipssinjkxy28szidnz6q71zyvsjyw";
    x86_64-darwin = "05v0gxal74igc29qjy0ficlyna17bzh1lpfqvyxdpg22is894h2l";
    aarch64-linux = "1x6lhcvdly3a2n0shp2vlgk3s2pj9byxn9dc9pjg4k5ff24dql7l";
    aarch64-darwin = "03knkj0y6n45lin0v6288zbq1nz5qh81ijyw1w3zrpd7pijn9j0x";
    armv7l-linux = "0iwlr5q1qwq3jgldrhz4bbyl3xmdhd4ss690x1lqb4vxm2m7v5jw";
  }.${system};

  sourceRoot = if stdenv.isDarwin then "" else ".";
in
  callPackage ./generic.nix rec {
    inherit sourceRoot;

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.67.2";
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
      maintainers = with maintainers; [ synthetica turion bobby285271 ];
      mainProgram = "codium";
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" "armv7l-linux" ];
    };
  }
