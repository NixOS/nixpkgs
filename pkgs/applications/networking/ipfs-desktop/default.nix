{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook,
  makeDesktopItem,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libnotify,
  libX11,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXScrnSaver,
  libXtst,
  libxcb,
  libxshmfence,
  mesa,
  nss,
  pango,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "ipfs-desktop";
  version = "0.46.0";

  src = fetchurl {
    url = "https://github.com/ipfs/ipfs-desktop/releases/download/v${version}/ipfs-desktop-${version}-linux-x64.tar.xz";
    hash = "";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    libxcb
    xorg.libxshmfence
    mesa
    nss
    pango
  ];

  dontBuild = true;
  dontConfigure = true;

  desktopItem = makeDesktopItem {
    name = "ipfs-desktop";
    exec = "ipfs-desktop";
    icon = "ipfs-desktop";
    comment = "An unobtrusive and user-friendly desktop application for IPFS";
    desktopName = "IPFS Desktop";
    genericName = "IPFS Desktop";
    categories = [
      "Network"
      "P2P"
      "FileTransfer"
    ];
    keywords = [
      "ipfs"
      "p2p"
      "distributed"
      "web"
      "dweb"
    ];
    startupWMClass = "IPFS Desktop";
    mimeTypes = [ "application/x-ipfs" ];
  };

  installPhase = ''
    runHook preInstall

    # Create directories
    mkdir -p $out/{bin,lib/ipfs-desktop,share/pixmaps}

    # Copy the pre-built application
    cp -r * $out/lib/ipfs-desktop/

    # Create wrapper script
    makeWrapper $out/lib/ipfs-desktop/ipfs-desktop $out/bin/ipfs-desktop \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --set ELECTRON_IS_DEV 0 \
      --set ELECTRON_FORCE_IS_PACKAGED 1

    # Install desktop file
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/

    # Copy icon if available
    if [ -f "resources/app.asar.unpacked/assets/icon.png" ]; then
      cp resources/app.asar.unpacked/assets/icon.png $out/share/pixmaps/ipfs-desktop.png
    elif [ -f "assets/icon.png" ]; then
      cp assets/icon.png $out/share/pixmaps/ipfs-desktop.png
    fi

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs})
  '';

  meta = {
    description = "Desktop application for IPFS";
    homepage = "https://github.com/ipfs/ipfs-desktop";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ ltpie123 ];
    platforms = lib.platforms.linux;
    mainProgram = "ipfs-desktop";
  };
}
