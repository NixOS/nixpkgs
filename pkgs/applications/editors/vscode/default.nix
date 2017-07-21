{ stdenv, lib, callPackage, fetchurl, unzip, atomEnv, makeDesktopItem,
  makeWrapper, libXScrnSaver, libxkbfile }:

let
  version = "1.14.0";
  channel = "stable";

  plat = {
    "i686-linux" = "linux-ia32";
    "x86_64-linux" = "linux-x64";
    "x86_64-darwin" = "darwin";
  }.${stdenv.system};

  sha256 = {
    "i686-linux" = "04xv9fr11j7k0yfb7aa2sdmq74hh43aarlvx8nxppzbn2k18dgb3";
    "x86_64-linux" = "1m252cpj4pck40rxnrbp1wapn5d4grn15x7d3s059xb965kga4k7";
    "x86_64-darwin" = "1hwjdrnrhvrmwbq935k4scgw68x817ms89gy471afbhpl65xmp8n";
  }.${stdenv.system};

  archive_fmt = if stdenv.system == "x86_64-darwin" then "zip" else "tar.gz";

  rpath = lib.concatStringsSep ":" [
    atomEnv.libPath
    "${lib.makeLibraryPath [libXScrnSaver]}/libXss.so.1"
    "${lib.makeLibraryPath [libxkbfile]}/libxkbfile.so.1"
    "$out/lib/vscode"
  ];

in
  stdenv.mkDerivation rec {
    name = "vscode-${version}";

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://vscode-update.azurewebsites.net/${version}/${plat}/${channel}";
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
      else [ makeWrapper libXScrnSaver libxkbfile ];

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
        --set-rpath "${rpath}" \
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
