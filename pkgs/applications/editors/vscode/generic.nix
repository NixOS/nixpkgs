{ stdenv, lib, makeDesktopItem
, unzip, libsecret, libXScrnSaver, libxshmfence, wrapGAppsHook
, gtk2, atomEnv, at-spi2-atk, autoPatchelfHook
, systemd, fontconfig, libdbusmenu

# Populate passthru.tests
, tests

# Attributes inherit from specific versions
, version, src, meta, sourceRoot
, executableName, longName, shortName, pname
}:

let
  inherit (stdenv.hostPlatform) system;
in
  stdenv.mkDerivation {

    inherit pname version src sourceRoot;

    passthru = {
      inherit executableName tests;
    };

    desktopItem = makeDesktopItem {
      name = executableName;
      desktopName = longName;
      comment = "Code Editing. Redefined.";
      genericName = "Text Editor";
      exec = "${executableName} %F";
      icon = "code";
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
        Icon=code
      '';
    };

    urlHandlerDesktopItem = makeDesktopItem {
      name = executableName + "-url-handler";
      desktopName = longName + " - URL Handler";
      comment = "Code Editing. Redefined.";
      genericName = "Text Editor";
      exec = executableName + " --open-url %U";
      icon = "code";
      startupNotify = "true";
      categories = "Utility;TextEditor;Development;IDE;";
      mimeType = "x-scheme-handler/vscode;";
      extraEntries = ''
        NoDisplay=true
        Keywords=vscode;
      '';
    };

    buildInputs = [ libsecret libXScrnSaver libxshmfence ]
      ++ lib.optionals (!stdenv.isDarwin) ([ gtk2 at-spi2-atk ] ++ atomEnv.packages);

    runtimeDependencies = lib.optional (stdenv.isLinux) [ (lib.getLib systemd) fontconfig.lib libdbusmenu ];

    nativeBuildInputs = [unzip] ++ lib.optionals (!stdenv.isDarwin) [ autoPatchelfHook wrapGAppsHook ];

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
    '' + (if system == "x86_64-darwin" then ''
      mkdir -p "$out/Applications/${longName}.app" $out/bin
      cp -r ./* "$out/Applications/${longName}.app"
      ln -s "$out/Applications/${longName}.app/Contents/Resources/app/bin/code" $out/bin/${executableName}
    '' else ''
      mkdir -p $out/lib/vscode $out/bin
      cp -r ./* $out/lib/vscode

      ln -s $out/lib/vscode/bin/${executableName} $out/bin

      mkdir -p $out/share/applications
      ln -s $desktopItem/share/applications/${executableName}.desktop $out/share/applications/${executableName}.desktop
      ln -s $urlHandlerDesktopItem/share/applications/${executableName}-url-handler.desktop $out/share/applications/${executableName}-url-handler.desktop

      mkdir -p $out/share/pixmaps
      cp $out/lib/vscode/resources/app/resources/linux/code.png $out/share/pixmaps/code.png

      # Override the previously determined VSCODE_PATH with the one we know to be correct
      sed -i "/ELECTRON=/iVSCODE_PATH='$out/lib/vscode'" $out/bin/${executableName}
      grep -q "VSCODE_PATH='$out/lib/vscode'" $out/bin/${executableName} # check if sed succeeded
    '') + ''
      runHook postInstall
    '';

    inherit meta;
  }
