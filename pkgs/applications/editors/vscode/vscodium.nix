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
    x86_64-linux = "1577wxmm8623aj513hxqcfim4d9p1r9wbla9my0c0c1x6pik0h8h";
    x86_64-darwin = "1n8q626nlqw78wlpfppzj365gmlz2swll6csg3ic7p4ik3nak95b";
    aarch64-linux = "1a7rkmhz456rsqw95lrknp1wqsdp63pkzh76vhzy5bazb1h081v0";
    armv7l-linux = "1qjik1r41c8n9fs7p09p0zdj8c5xgqjniwv23hcy6mp28i4whclr";
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
    # The update script doesn't correctly change the hash for darwin, so please:
    # nixpkgs-update: no auto update

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.54.3";
    pname = "vscodium";

    executableName = "codium";
    longName = "VSCodium";
    shortName = "vscodium";

    src = fetchurl {
      url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
      inherit sha256;
    };

    tests = nixosTests.vscodium;

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
