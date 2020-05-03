{ stdenv, callPackage, fetchurl }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  sha256 = {
    x86_64-linux = "141hwj1a2bsgzpfk354dnnmg4ak00fss3xsgqplyk949pbk6v1af";
    x86_64-darwin = "0fi8nz1gayzw5dp6d3m7jsmij3jj4yjg5rk1s9w6falpgka76dm1";
  }.${system};

  sourceRoot = {
    x86_64-linux = ".";
    x86_64-darwin = "";
  }.${system};
in
  callPackage ./generic.nix rec {
    inherit sourceRoot;
    # The update script doesn't correctly change the hash for darwin, so please:
    # nixpkgs-update: no auto update

    # Please backport all compatible updates to the stable release.
    # This is important for the extension ecosystem.
    version = "1.44.2";
    pname = "vscodium";

    executableName = "codium";
    longName = "VSCodium";
    shortName = "Codium";

    src = fetchurl {
      url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
      inherit sha256;
    };

    meta = with stdenv.lib; {
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
      platforms = [ "x86_64-linux" "x86_64-darwin" ];
    };
  }
