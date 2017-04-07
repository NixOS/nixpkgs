{ stdenv, lib, callPackage, fetchurl, unzip, atomEnv, makeDesktopItem,
  makeWrapper, libXScrnSaver }:

let
  version = "1.11.1";
  rev = "d9484d12b38879b7f4cdd1150efeb2fd2c1fbf39";
  channel = "stable";

  # The revision and build timestamps can be obtained with the following
  # command (see https://github.com/NixOS/nixpkgs/issues/22465):
  # for a in x64 ia32; do
  #   curl -w "%{url_effective}\n" -I -L -s -S -o /dev/null \
  #     "https://vscode-update.azurewebsites.net/latest/linux-${arch}/stable" \
  # done

  sha256 = if stdenv.system == "i686-linux"    then "14wdblh7q3m5qdsm34dpg5p7qk6llrbqk60md8wd0fb4chpvrq94"
      else if stdenv.system == "x86_64-linux"  then "0rmzvaiar3y062mbrggiwjbwxs7izcih5333rn208ax4jxmbk4pc"
      else if stdenv.system == "x86_64-darwin" then "1f3zdwsz0l6r7c2k25a7j5m0dl78219jzg4axcmbfa2qcs2hw0x6"
      else throw "Unsupported system: ${stdenv.system}";

  urlBase = "https://az764295.vo.msecnd.net/${channel}/${rev}/";

  urlStr = if stdenv.system == "i686-linux" then
        urlBase + "code-${channel}-code_${version}-1491487843_i386.tar.gz"
      else if stdenv.system == "x86_64-linux" then
        urlBase + "code-${channel}-code_${version}-1491486998_amd64.tar.gz"
      else if stdenv.system == "x86_64-darwin" then
        urlBase + "VSCode-darwin-${channel}.zip"
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
      comment = "Code editor redefined and optimized for building and debugging modern web and cloud applications";
      desktopName = "Visual Studio Code";
      genericName = "Text Editor";
      categories = "GNOME;GTK;Utility;TextEditor;Development;";
    };

    buildInputs = if stdenv.system == "x86_64-darwin"
      then [ unzip makeWrapper libXScrnSaver ]
      else [ makeWrapper libXScrnSaver ];

    installPhase =
      if stdenv.system == "x86_64-darwin" then ''
        mkdir -p $out/lib/vscode $out/bin
        cp -r ./* $out/lib/vscode
        ln -s $out/lib/vscode/Contents/Resources/app/bin/code $out/bin
      '' else ''
        mkdir -p $out/lib/vscode $out/bin
        cp -r ./* $out/lib/vscode
        ln -s $out/lib/vscode/bin/code $out/bin

        mkdir -p $out/share/applications
        cp $desktopItem/share/applications/* $out/share/applications

        mkdir -p $out/share/pixmaps
        cp $out/lib/vscode/resources/app/resources/linux/code.png $out/share/pixmaps/code.png
      '';

    postFixup = lib.optionalString (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:${stdenv.lib.makeLibraryPath [libXScrnSaver]}/libXss.so.1:$out/lib/vscode" \
        $out/lib/vscode/code
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
