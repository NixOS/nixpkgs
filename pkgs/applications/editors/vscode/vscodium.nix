{ stdenv, callPackage, fetchurl }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    "x86_64-linux" = "linux-x64";
    "x86_64-darwin" = "darwin";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";

  sha256 = {
    "x86_64-linux" = "0j6188gm66bwffyg0vn3ak8242vs2vb2cw92b9wfkiml6sfg555n";
    "x86_64-darwin" = "0iblg0hn6jdds7d2hzp0icb5yh6hhw3fd5g4iim64ibi7lpwj2cj";
  }.${system};
in
  callPackage ./generic.nix rec {

    version = "1.37.1";
    pname = "vscodium";

    executableName = "codium";
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
      platforms = [ "x86_64-linux" "x86_64-darwin" ];
    };
  }
