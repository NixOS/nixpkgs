{ stdenv, callPackage, fetchurl, unzip
, ...
} @ args:

let
  atomEnv = callPackage ../../../development/tools/electron/env-atom.nix (args);

  version = "0.10.10";
  rev = "5b5f4db87c10345b9d5c8d0bed745bcad4533135";
  sha256 = if stdenv.system == "i686-linux"    then "1mmgq4fxi2h4hvz7yxgzzyvlznkb42qwr8i1g2b1akdlgnrvvpby"
      else if stdenv.system == "x86_64-linux"  then "1zjb6mys5qs9mb21rpgpnbgq4gpnw6gsgfn5imf7ca7myk1bxnvk"
      else if stdenv.system == "x86_64-darwin" then "0y1as2s6nhicyvdfszphhqp76iv9wcygglrl2f0jamm98g9qp66p"
      else throw "Unsupported system: ${stdenv.system}";

  urlMod = if stdenv.system == "i686-linux" then "linux-ia32"
      else if stdenv.system == "x86_64-linux" then "linux-x64"
      else if stdenv.system == "x86_64-darwin" then "darwin"
      else throw "Unsupported system: ${stdenv.system}";

in
  stdenv.mkDerivation rec {
    name = "vscode-${version}";
    inherit version;

    src = fetchurl {
      url = "https://az764295.vo.msecnd.net/stable/${rev}/VSCode-${urlMod}-stable.zip";
      inherit sha256;
    };

    buildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out/bin
      cp -r ./* $out/bin

      ${if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then ''
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/bin/code
      '' else ""}
    '';

    postFixup = ''
      ${if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then ''
        patchelf \
        --set-rpath "${atomEnv}/lib:${atomEnv}/lib64:$out/bin:$(patchelf --print-rpath $out/bin/code)" \
        $out/bin/code
      '' else ""}
    '';

    meta = with stdenv.lib; {
      description = "Visual Studio Code is an open source source code editor developed by Microsoft for Windows, Linux and OS X.";
      longDescription = ''
        Visual Studio Code is an open source source code editor developed by Microsoft for Windows, Linux and OS X.
        It includes support for debugging, embedded Git control, syntax highlighting, intelligent code completion, snippets, and code refactoring.
        It is also customizable, so users can change the editor's theme, keyboard shortcuts, and preferences.
      '';
      homepage = http://code.visualstudio.com/;
      downloadPage = https://code.visualstudio.com/Updates;
      license = licenses.unfree;
      platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    };
  }
