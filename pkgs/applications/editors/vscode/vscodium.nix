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
    "i686-linux" = "0i572kxc7h63jxl6mw5k3gv08m9padqkky5k1f3w0d638hxhfl23";
    "x86_64-linux" = "0577lqpfrjgwbj27hm59kflb558mkl2nx00ys0hwndayqv0bfnvg";
    "x86_64-darwin" = "047sj0j9k74fvw9fc1ripqk2vy4v17jw488m7r95nf0cyyk08xg0";
  }.${system};
in
  callPackage ./generic.nix rec {

    version = "1.35.1";
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
      platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    };
  }
