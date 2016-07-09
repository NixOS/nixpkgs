{ stdenv, lib, callPackage, fetchurl, unzip, atomEnv, makeDesktopItem }:

let
  version = "1.2.1";
  rev = "fe7f407b95b7f78405846188259504b34ef72761";

  sha256 = if stdenv.system == "i686-linux"    then "10jm92i88ds6q5rybm19z0z3g35gqhp6jqr2ldxcryijl17gj1n5"
      else if stdenv.system == "x86_64-linux"  then "0jg40gbz3s9vxqpnkg267ck8kbwvgiqhw8hsn26r42wyxmj8773v"
      else if stdenv.system == "x86_64-darwin" then "1b241wfzp8m0nvycjprwv39l4pax9lyqzngj4ghkkdnb8ai2hd2z"
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

    desktopItem = makeDesktopItem {
      name = "code";
      exec = "code";
      icon = "code";
      comment = "Visual Studio Code is a code editor redefined and optimized for building and debugging modern web and cloud applications";
      desktopName = "Visual Studio Code";
      genericName = "Text Editor";
      categories = "GNOME;GTK;Utility;TextEditor;Development;";
    };

    buildInputs = [ unzip ];

    installPhase = ''
      mkdir -p $out/lib/vscode $out/bin
      cp -r ./* $out/lib/vscode
      ln -s $out/lib/vscode/code $out/bin

      mkdir -p $out/share/applications
      cp $desktopItem/share/applications/* $out/share/applications

      mkdir -p $out/share/pixmaps
      cp $out/lib/vscode/resources/app/resources/linux/code.png $out/share/pixmaps/code.png
    '';

    postFixup = lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:$out/lib/vscode" \
        $out/lib/vscode/code
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
