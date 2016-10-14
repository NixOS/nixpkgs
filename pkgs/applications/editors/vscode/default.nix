{ stdenv, lib, callPackage, fetchOneOf, unzip, atomEnv, makeDesktopItem }:

let
  version = "1.6.1";
  rev = "9e4e44c19e393803e2b05fe2323cf4ed7e36880e";
  urlBase = "https://az764295.vo.msecnd.net/stable/${rev}/";
in
  stdenv.mkDerivation rec {
    name = "vscode-${version}";
    inherit version;

    src = fetchOneOf stdenv.system {
      "i686-linux" = {
        url = "${urlBase}/code-stable-code_${version}-1476372351_i386.tar.gz";
        sha256 = "1aks84siflpjbd2s9y1f0vvvf3nas4f50cimjf25lijxzjxrlivy";
      };
      "x86_64-linux" = {
        url = "${urlBase}/code-stable-code_${version}-1476373175_amd64.tar.gz";
        sha256 = "05kbi081ih64fadj4k74grkk9ca3wga6ybwgs5ld0bal4ilw1q6i";
      };
      "x86_64-darwin" = {
        url = "${urlBase}/VSCode-darwin-stable.zip";
        sha256 = "00p2m8b0l3pkf5k74szw6kcql3j1fjnv3rwnhy24wfkg4b4ah2x9";
      };
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
