{ stdenv, lib, callPackage, fetchurl, unzip, atomEnv, makeDesktopItem,
  makeWrapper, libXScrnSaver }:

let
  version = "1.8.0";
  rev = "38746938a4ab94f2f57d9e1309c51fd6fb37553d";

  sha256 = if stdenv.system == "i686-linux"    then "0p7r1i71v2ab4dzlwh43hqih958a31cqskf64ds4vgc35x2mfjcq"
      else if stdenv.system == "x86_64-linux"  then "1k15701jskk7w5kwzlzfri96vvw7fcinyfqqafls8nms8h5csv76"
      else if stdenv.system == "x86_64-darwin" then "12fqz62gs2wcg2wwx1k6gv2gqil9c54yq254vk3rqdf82q9zyapk"
      else throw "Unsupported system: ${stdenv.system}";

  urlBase = "https://az764295.vo.msecnd.net/stable/${rev}/";

  urlStr = if stdenv.system == "i686-linux" then
        urlBase + "code-stable-code_${version}-1481650382_i386.tar.gz"
      else if stdenv.system == "x86_64-linux" then
        urlBase + "code-stable-code_${version}-1481651903_amd64.tar.gz"
      else if stdenv.system == "x86_64-darwin" then
        urlBase + "VSCode-darwin-stable.zip"
      else throw "Unsupported system: ${stdenv.system}";
in
  stdenv.mkDerivation rec {
    name = "vscode-${version}";
    inherit version;

    src = fetchurl {
      url = urlStr;
      inherit sha256;
    };

    desktopItem = makeDesktopItem {
      name = "code";
      exec = "code";
      icon = "code";
      comment = ''
        Code editor redefined and optimized for building and debugging modern
        web and cloud applications
      '';
      desktopName = "Visual Studio Code";
      genericName = "Text Editor";
      categories = "GNOME;GTK;Utility;TextEditor;Development;";
    };

    buildInputs = if stdenv.system == "x86_64-darwin"
      then [ unzip makeWrapper libXScrnSaver ]
      else [ makeWrapper libXScrnSaver ];

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

      wrapProgram $out/bin/code \
        --prefix LD_PRELOAD : ${stdenv.lib.makeLibraryPath [ libXScrnSaver ]}/libXss.so.1
    '';

    meta = with stdenv.lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and OS X
      '';
      longDescription = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and OS X. It includes support for debugging, embedded Git
        control, syntax highlighting, intelligent code completion, snippets,
        and code refactoring. It is also customizable, so users can change the
        editor's theme, keyboard shortcuts, and preferences
      '';
      homepage = http://code.visualstudio.com/;
      downloadPage = https://code.visualstudio.com/Updates;
      license = licenses.unfree;
      platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    };
  }
