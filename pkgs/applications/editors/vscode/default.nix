{ stdenv, lib, callPackage, fetchurl, unzip, atomEnv, makeDesktopItem }:

let
  version = "1.5.1";
  rev = "07d663dc1bd848161edf4cd4ce30cce410d3d877";

  sha256 = if stdenv.system == "i686-linux"    then "1a2854snjdmfhzx6qwib4iw3qjhlmlf09dlsbbvh24zbrjphnd85"
      else if stdenv.system == "x86_64-linux"  then "0gg2ad7sp02ffv7la61hh9h4vfw8qkfladbhwlh5y4axbbrx17r7"
      else if stdenv.system == "x86_64-darwin" then "18q4ldnmm619vv8yx6rznpznpcc19zjczmcidr34552i5qfg5xsz"
      else throw "Unsupported system: ${stdenv.system}";

  urlBase = "https://az764295.vo.msecnd.net/stable/${rev}/";

  urlStr = if stdenv.system == "i686-linux" then
        urlBase + "code-stable-code_${version}-1473369468_i386.tar.gz"
      else if stdenv.system == "x86_64-linux" then
        urlBase + "code-stable-code_${version}-1473370243_amd64.tar.gz"
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
      comment = "Visual Studio Code is a code editor redefined and optimized for building and debugging modern web and cloud applications";
      desktopName = "Visual Studio Code";
      genericName = "Text Editor";
      categories = "GNOME;GTK;Utility;TextEditor;Development;";
    };

    buildInputs = if stdenv.system == "x86_64-darwin"
      then [ unzip ]
      else [ ];

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
