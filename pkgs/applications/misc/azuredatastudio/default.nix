{ stdenv
, lib
, fetchurl
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, alsa-lib
, at-spi2-atk
, at-spi2-core
, cairo
, cups
, curl
, dbus
, expat
, gdk-pixbuf
, glib
, gnutar
, gtk3
, icu
, libdrm
, libunwind
, libuuid
, libxkbcommon
, mesa
, nspr
, nss
, openssl
, pango
, systemd
, xorg
, zlib
}:

# from justinwoo/azuredatastudio-nix
# https://github.com/justinwoo/azuredatastudio-nix/blob/537c48aa3981cd1a82d5d6e508ab7e7393b3d7c8/default.nix

let
  desktopItem = makeDesktopItem {
    name = "azuredatastudio";
    desktopName = "Azure Data Studio";
    comment = "Data Management Tool that enables you to work with SQL Server, Azure SQL DB and SQL DW from Windows, macOS and Linux.";
    genericName = "Text Editor";
    exec = "azuredatastudio --no-sandbox --unity-launch %F";
    icon = "azuredatastudio";
    startupNotify = true;
    startupWMClass = "azuredatastudio";
    categories = [ "Utility" "TextEditor" "Development" "IDE" ];
    mimeTypes = [ "text/plain" "inode/directory" "application/x-azuredatastudio-workspace" ];
    keywords = [ "azuredatastudio" ];
    actions.new-empty-window = {
      name = "New Empty Window";
      exec = "azuredatastudio --no-sandbox --new-window %F";
      icon = "azuredatastudio";
    };
  };

  urlHandlerDesktopItem = makeDesktopItem {
    name = "azuredatastudio-url-handler";
    desktopName = "Azure Data Studio - URL Handler";
    comment = "Azure Data Studio";
    genericName = "Text Editor";
    exec = "azuredatastudio --no-sandbox --open-url %U";
    icon = "azuredatastudio";
    startupNotify = true;
    startupWMClass = "azuredatastudio";
    categories = [ "Utility" "TextEditor" "Development" "IDE" ];
    mimeTypes = [ "x-scheme-handler/azuredatastudio" ];
    keywords = [ "azuredatastudio" ];
    noDisplay = true;
  };
in
stdenv.mkDerivation rec {

  pname = "azuredatastudio";
  version = "1.44.1";

  desktopItems = [ desktopItem urlHandlerDesktopItem ];

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "https://azuredatastudio-update.azurewebsites.net/${version}/linux-x64/stable";
    sha256 = "sha256-6kEV331kt+/7/uWKZmTTkJX4P06CfxC8Ogq052qlUEg=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    libuuid
    at-spi2-core
    at-spi2-atk
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pixmaps
    cp ${targetPath}/resources/app/resources/linux/code.png $out/share/pixmaps/azuredatastudio.png

    runHook postInstall
  '';

  # change this to azuredatastudio-insiders for insiders releases
  edition = "azuredatastudio";
  targetPath = "$out/${edition}";

  unpackPhase = ''
    mkdir -p ${targetPath}
    ${gnutar}/bin/tar xf $src --strip 1 -C ${targetPath}
  '';

  sqltoolsserviceRpath = lib.makeLibraryPath [
    stdenv.cc.cc
    libunwind
    libuuid
    icu
    openssl
    zlib
    curl
  ];

  # this will most likely need to be updated when azuredatastudio's version changes
  sqltoolsservicePath = "${targetPath}/resources/app/extensions/mssql/sqltoolsservice/Linux/4.7.1.6";

  rpath = lib.concatStringsSep ":" [
    (lib.makeLibraryPath [
      alsa-lib
      at-spi2-atk
      cairo
      cups
      dbus
      expat
      gdk-pixbuf
      glib
      gtk3
      mesa
      nss
      nspr
      libdrm
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxshmfence
      libxkbcommon
      xorg.libxkbfile
      pango
      stdenv.cc.cc.lib
      systemd
    ])
    targetPath
    sqltoolsserviceRpath
  ];

  fixupPhase = ''
    fix_sqltoolsservice()
    {
      mv ${sqltoolsservicePath}/$1 ${sqltoolsservicePath}/$1_old
      patchelf \
        --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
        ${sqltoolsservicePath}/$1_old

      makeWrapper \
        ${sqltoolsservicePath}/$1_old \
        ${sqltoolsservicePath}/$1 \
        --set LD_LIBRARY_PATH ${sqltoolsserviceRpath}
    }

    fix_sqltoolsservice MicrosoftSqlToolsServiceLayer
    fix_sqltoolsservice MicrosoftSqlToolsCredentials
    fix_sqltoolsservice SqlToolsResourceProviderService

    patchelf \
      --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
      ${targetPath}/${edition}

    mkdir -p $out/bin
    makeWrapper \
      ${targetPath}/bin/${edition} \
      $out/bin/azuredatastudio \
      --set LD_LIBRARY_PATH ${rpath}
  '';

  meta = {
    maintainers = with lib.maintainers; [ xavierzwirtz ];
    description = "A data management tool that enables working with SQL Server, Azure SQL DB and SQL DW";
    homepage = "https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    mainProgram = "azuredatastudio";
  };
}
