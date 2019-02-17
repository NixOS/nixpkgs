{ stdenv, lib, fetchurl, makeDesktopItem
, unzip, libsecret, libXScrnSaver, wrapGAppsHook
, gtk2, atomEnv, at-spi2-atk, autoPatchelfHook
, systemd, fontconfig
, isInsiders ? false }:

let
  executableName = "code" + lib.optionalString isInsiders "-insiders";

  inherit (stdenv.hostPlatform) system;

  plat = {
    "i686-linux" = "linux-ia32";
    "x86_64-linux" = "linux-x64";
    "x86_64-darwin" = "darwin";
  }.${system};

  sha256 = {
    "i686-linux" = "04kbx1cx40lsy9irxy1arp1rixzk49ldhg34w3llmfbx63a4hchf";
    "x86_64-linux" = "1plvx0mjcbizl6iffib95p5224r9frf0mn6c5xp14p3qnrp32jhm";
    "x86_64-darwin" = "14h9gs6jpxydgd1h16ybq3ifw5jc7k83yg22pw3sk6vhy7hx7pxr";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";
in
  stdenv.mkDerivation rec {
    name = "vscode-${version}";
    version = "1.31.1";

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

    buildInputs = (if stdenv.isDarwin
      then [ unzip ]
      else [ gtk2 at-spi2-atk wrapGAppsHook ] ++ atomEnv.packages)
        ++ [ libsecret libXScrnSaver ];

    nativeBuildInputs = lib.optional (!stdenv.isDarwin) autoPatchelfHook;

    dontBuild = true;
    dontConfigure = true;

    installPhase =
      if system == "x86_64-darwin" then ''
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

    preFixup = lib.optionalString (system == "i686-linux" || system == "x86_64-linux") ''
      gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ systemd fontconfig ]})
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
      homepage = https://code.visualstudio.com/;
      downloadPage = https://code.visualstudio.com/Updates;
      license = licenses.unfree;
      maintainers = with maintainers; [ eadwu ];
      platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    };
  }
