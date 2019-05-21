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
    "i686-linux" = "1vr3mblg5223k56yqi9fqwa7yg8qi4r3nkw6ssf87gs8jwfxa47l";
    "x86_64-linux" = "1vqq365zw44ll22i06bxxviyywv1v2f71c2mricrz3faz25c3lvm";
    "x86_64-darwin" = "0pa5cz8kq45q375b74kaa8qn1h0r1mp9amh5gsprg3hx89xzvhxi";
  }.${system};
in
  callPackage ./generic.nix rec {

    version = "1.34.0";
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
