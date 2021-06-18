{ stdenv, lib, makeDesktopItem
, unzip, libXScrnSaver, wrapGAppsHook
, gtk2, atomEnv, at-spi2-atk, autoPatchelfHook
, systemd, fontconfig, libdbusmenu

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
      inherit executableName;
    };

    desktopItem = makeDesktopItem {
      name = executableName;
      desktopName = longName;
      comment = "Turn Any Websites Into Desktop Apps.";
      genericName = "Site-specific Browser";
      exec = "${executableName} %F";
      icon = "webcatalog";
      startupNotify = "true";
      categories = "Network;WebBrowser;";
      mimeType = "text/plain;inode/directory;";
    };

    buildInputs = (if stdenv.isDarwin
      then [ unzip ]
      else [ gtk2 at-spi2-atk wrapGAppsHook ] ++ atomEnv.packages)
        ++ [ libXScrnSaver ];

    runtimeDependencies = lib.optional (stdenv.isLinux) [ (lib.getLib systemd) fontconfig.lib libdbusmenu ];

    nativeBuildInputs = lib.optional (!stdenv.isDarwin) autoPatchelfHook;

    dontBuild = true;
    dontConfigure = true;

    installPhase =
      if system == "x86_64-darwin" then ''
        mkdir -p "$out/Applications/${longName}.app" $out/bin
        cp -r ./* "$out/Applications/${longName}.app"
        ln -s "$out/Applications/${longName}.app/Contents/Resources/app/bin/code" $out/bin/${executableName}
      '' else ''
        mkdir -p $out/lib/webcatalog $out/bin
        cp -r ./* $out/lib/webcatalog

        ln -s $out/lib/webcatalog/bin/${executableName} $out/bin

        mkdir -p $out/share/applications
        ln -s $desktopItem/share/applications/${executableName}.desktop $out/share/applications/${executableName}.desktop

        mkdir -p $out/share/pixmaps
        cp $out/lib/webcatalog/resources/app/resources/linux/code.png $out/share/pixmaps/code.png
      '';

    inherit meta;
  }
