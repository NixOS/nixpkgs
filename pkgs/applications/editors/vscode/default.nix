{ stdenv, lib, fetchurl, makeDesktopItem
, unzip, libsecret, libXScrnSaver, wrapGAppsHook
, gtk2, atomEnv, at-spi2-atk, autoPatchelfHook
, systemd, fontconfig
, isInsiders ? false }:

let
  executableName = "code" + lib.optionalString isInsiders "-insiders";
  longName = "Visual Studio Code" + lib.optionalString isInsiders " - Insiders";
  shortName = "Code" + lib.optionalString isInsiders " - Insiders";

  inherit (stdenv.hostPlatform) system;

  plat = {
    "i686-linux" = "linux-ia32";
    "x86_64-linux" = "linux-x64";
    "x86_64-darwin" = "darwin";
  }.${system};

  sha256 = {
    "i686-linux" = "09hm0qm0hajfqn5mn9m60kgs7gkbk2vx6x5llvndfncazi0s1pjn";
    "x86_64-linux" = "0zb71ca2v1a4hgh7dfm2ad558ipw5pgj8pvxb2k9n0454g2nn14k";
    "x86_64-darwin" = "0kqcfa9rymzgk4ixl2xj67kk4rij3f4vim86wqj1d1m2fja8n8kx";
  }.${system};

  archive_fmt = if system == "x86_64-darwin" then "zip" else "tar.gz";
in
  stdenv.mkDerivation rec {
    name = "vscode-${version}";
    version = "1.32.0";

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
      desktopName = longName;
      comment = "Code Editing. Redefined.";
      genericName = "Text Editor";
      exec = executableName;
      icon = "@out@/share/pixmaps/code.png";
      startupNotify = "true";
      categories = "Utility;TextEditor;Development;IDE;";
      mimeType = "text/plain;inode/directory;";
      extraEntries = ''
        StartupWMClass=${shortName}
        Actions=new-empty-window;
        Keywords=vscode;

        [Desktop Action new-empty-window]
        Name=New Empty Window
        Exec=${executableName} --new-window %F
        Icon=@out@/share/pixmaps/code.png
      '';
    };

    urlHandlerDesktopItem = makeDesktopItem {
      name = executableName + "-url-handler";
      desktopName = longName + " - URL Handler";
      comment = "Code Editing. Redefined.";
      genericName = "Text Editor";
      exec = executableName + " --open-url %U";
      icon = "@out@/share/pixmaps/code.png";
      startupNotify = "true";
      categories = "Utility;TextEditor;Development;IDE;";
      mimeType = "x-scheme-handler/vscode;";
      extraEntries = ''
        NoDisplay=true
        Keywords=vscode;
      '';
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
        substitute $urlHandlerDesktopItem/share/applications/${executableName}-url-handler.desktop $out/share/applications/${executableName}-url-handler.desktop \
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
