{ lib, stdenv, callPackage, fetchurl, nixosTests }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin-x64";
    aarch64-linux = "linux-arm64";
    armv7l-linux = "linux-armhf";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "1l3khnqb8icapnwk4pr4s639dqsvjy1k51km2p9ywnrjdg9byc12";
    x86_64-darwin = "1lb63rz9mzcw5yg3cqi022m1ldvmbxz5z70axc9n6dci8aals663";
    aarch64-linux = "0c0rxzhayklgnaf0r4hj6rwdh5qbb449vi5ja0asfyni4k2nalr5";
    armv7l-linux = "0xs8wsad64cni8vpzfh2aqgdsnsy4hwc25msl79prvh17794k8jy";
  }.${system};

  sourceRoot = {
    x86_64-linux = ".";
    x86_64-darwin = "";
    aarch64-linux = ".";
    armv7l-linux = ".";
  }.${system};
in
  callPackage ./generic.nix rec {
    inherit sourceRoot;

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.60.0";
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
      maintainers = with maintainers; [ synthetica turion ];
      platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "armv7l-linux" ];
    };
  }
