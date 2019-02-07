{ stdenv, lib, fetchurl, unzip, atomEnv, makeDesktopItem,
  gtk2, wrapGAppsHook, libXScrnSaver, libxkbfile, libsecret,
  isInsiders ? false }:

let
  executableName = "code" + lib.optionalString isInsiders "-insiders";

  plat = {
    "i686-linux" = "linux-ia32";
    "x86_64-linux" = "linux-x64";
    "x86_64-darwin" = "darwin";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    "i686-linux" = "1g73fay6fxlqhalkqq5m6rjbp68k9npk0rrxrkhdj8mw0cz74dpm";
    "x86_64-linux" = "0mil8n5i2ajdyrgq862wq59ajy2122rvvn7m7mxq4ab92sk26rix";
    "x86_64-darwin" = "07r52scs1sgafzxqal39r8vf9p9qqvwwx8f6z09gqcf6clr6k48q";
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
    version = "1.30.2";

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://vscode-update.azurewebsites.net/${version}/${plat}/stable";
      inherit sha256;
    };

    passthru = {
      inherit executableName;
    };

    desktopItem = makeDesktopItem {
      name = executableName;
      exec = executableName;
      icon = "@out@/share/pixmaps/code.png";
      comment = "Code editor redefined and optimized for building and debugging modern web and cloud applications";
      desktopName = "Visual Studio Code" + lib.optionalString isInsiders " Insiders";
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
        ln -s $out/lib/vscode/Contents/Resources/app/bin/${executableName} $out/bin
      '' else ''
        mkdir -p $out/lib/vscode $out/bin
        cp -r ./* $out/lib/vscode

        substituteInPlace $out/lib/vscode/bin/${executableName} --replace '"$CLI" "$@"' '"$CLI" "--skip-getting-started" "$@"'

        ln -s $out/lib/vscode/bin/${executableName} $out/bin

        mkdir -p $out/share/applications
        substitute $desktopItem/share/applications/${executableName}.desktop $out/share/applications/${executableName}.desktop \
          --subst-var out

        mkdir -p $out/share/pixmaps
        cp $out/lib/vscode/resources/app/resources/linux/code.png $out/share/pixmaps/code.png
      '';

    postFixup = lib.optionalString (stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux") ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${rpath}" \
        $out/lib/vscode/${executableName}

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
