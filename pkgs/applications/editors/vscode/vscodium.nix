{ lib, stdenv, makeDesktopItem, callPackage, fetchurl, nixosTests, commandLineArgs ? "", useVSCodeRipgrep ? stdenv.isDarwin }:

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
    x86_64-linux = "1n3gb12asid2qwwzf9fj974ws9n7has9l23ni8jscx9cp63l5rbl";
    x86_64-darwin = "0gkplg2c5g7964m58fmv7b70d69g4yqrax5zn1rm4rl2agxgwyff";
    aarch64-linux = "0412222l9r81f3aa3zlzrg42hzslvvck5kds7zrmpssjrd41jxfh";
    aarch64-darwin = "1iv49m646vsbcgaxydxhpjbxspz7918brdk51gmbqf258shf8rii";
    armv7l-linux = "1sblaigrxscx4l1kln1zxzm5da5lr50y1k6qb4igq6wxbdx55iay";
  }.${system} or throwSystem;

  sourceRoot = lib.optionalString (!stdenv.isDarwin) ".";
in
  callPackage ./binary-generic.nix rec {
    inherit sourceRoot commandLineArgs useVSCodeRipgrep;

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.88.1.24104";
    pname = "vscodium";

    executableName = "codium";
    longName = "VSCodium";
    shortName = "vscodium";


    common = import ./common.nix {
      inherit
        lib
        executableName
        longName
        shortName
        makeDesktopItem
        ;
    };

    src = fetchurl {
      url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
      inherit sha256;
    };

    tests = nixosTests.vscodium;

    updateScript = ./update-vscodium.sh;

    meta = common.meta // {
      homepage = "https://github.com/VSCodium/vscodium";
      downloadPage = "https://github.com/VSCodium/vscodium/releases";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      maintainers = with lib.maintainers; [ synthetica bobby285271 ludovicopiero ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" "armv7l-linux" ];
    };
  }
