{ stdenv, lib, fetchurl, unzip, atomEnv, makeDesktopItem,
  gtk2, wrapGAppsHook, libXScrnSaver, libxkbfile, libsecret }:

let
  version = "1.26.1";
  channel = "stable";

  plat = {
    "i686-linux" = "linux-ia32";
    "x86_64-linux" = "linux-x64";
    "x86_64-darwin" = "darwin";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    "i686-linux" = "1g7kqbz6mrf8ngx2bnwpi9fifq5rjznxgsgwjb532z3nh92ypa8n";
    "x86_64-linux" = "02yldycakn5zxj1ji4nmhdyazqlkjqpzdj3g8j501c3j28pgiwjy";
    "x86_64-darwin" = "0pnsfkh20mj7pzqw7wlfd98jqc6a1mnsq1iira15n7fafqgj8zpl";
  }.${stdenv.hostPlatform.system};

  archive_fmt = if stdenv.hostPlatform.system == "x86_64-darwin" then "zip" else "tar.gz";

  rpath = lib.concatStringsSep ":" [
    atomEnv.libPath
    "${lib.makeLibraryPath [gtk2]}"
    "${lib.makeLibraryPath [libsecret]}/libsecret-1.so.0"
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

    buildInputs = if stdenv.hostPlatform.system == "x86_64-darwin"
      then [ unzip libXScrnSaver libsecret ]
      else [ wrapGAppsHook libXScrnSaver libxkbfile libsecret ];

    installPhase =
      if stdenv.hostPlatform.system == "x86_64-darwin" then ''
        mkdir -p $out/lib/vscode $out/bin
        cp -r ./* $out/lib/vscode
        ln -s $out/lib/vscode/Contents/Resources/app/bin/code $out/bin
      '' else ''
        mkdir -p $out/lib/vscode $out/bin
        cp -r ./* $out/lib/vscode

        substituteInPlace $out/lib/vscode/bin/code --replace '"$CLI" "$@"' '"$CLI" "--skip-getting-started" "$@"'

        ln -s $out/lib/vscode/bin/code $out/bin

        mkdir -p $out/share/applications
        cp $desktopItem/share/applications/* $out/share/applications

        mkdir -p $out/share/pixmaps
        cp $out/lib/vscode/resources/app/resources/linux/code.png $out/share/pixmaps/code.png
      '';

    postFixup = lib.optionalString (stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux") ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${rpath}" \
        $out/lib/vscode/code

      patchelf \
        --set-rpath "${rpath}" \
        $out/lib/vscode/resources/app/node_modules.asar.unpacked/keytar/build/Release/keytar.node

      patchelf \
        --set-rpath "${rpath}" \
        "$out/lib/vscode/resources/app/node_modules.asar.unpacked/native-keymap/build/Release/\
      keymapping.node"

      ln -s ${lib.makeLibraryPath [libsecret]}/libsecret-1.so.0 $out/lib/vscode/libsecret-1.so.0
    '';

    meta = with stdenv.lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS
      '';
      longDescription = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS. It includes support for debugging, embedded Git
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
