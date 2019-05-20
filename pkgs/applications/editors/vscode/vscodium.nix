{ stdenv, lib, callPackage, fetchurl, fetchpatch }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    "i686-linux" = "linux-ia32";
    "x86_64-linux" = "linux-x64";
    "x86_64-darwin" = "darwin";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  sha256 = {
    "i686-linux" = "c45be9ff32a5acef91befc85d545402daac5cef627fe8f17fea40ae387b35b22";
    "x86_64-linux" = "7a87f19bc48cbe017321c72da244d879a7da364b92b3a89b742d437ffcd585d3";
    "x86_64-darwin" = "e393be5dd82ea1900e3a0597b6cb2e4c924b6acda4297d9d3eff5abcc857f32c";
  }.${system};
in
  callPackage ./generic.nix rec {

    version = "1.33.1";
    pname = "vscodium";

    executableName = "vscodium";
    longName = "VSCodium";
    shortName = "Codium";

    src = fetchurl {
      url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
      inherit sha256;
    };

    sourceRoot = ".";

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
      homepage = https://github.com/VSCodium/vscodium;
      downloadPage = https://github.com/VSCodium/vscodium/releases;
      license = licenses.mit;
      maintainers = with maintainers; [];
      platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    };
  }
