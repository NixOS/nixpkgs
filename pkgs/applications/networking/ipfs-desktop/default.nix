{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook,
  desktop-file-utils,
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
    sha256 = "6ff6535010c744c8e17c66bf40f5a3fa043cf6ed5a5fc5463868cebcdaba6a1f";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    desktop-file-utils
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

  # No build phase needed - we're using pre-built binaries
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    
    # Create directories
    mkdir -p $out/{bin,share/applications,share/pixmaps}
    
    # Copy the pre-built application to a subdirectory
    mkdir -p $out/lib/ipfs-desktop
    cp -r * $out/lib/ipfs-desktop/
    
    # Create a wrapper script for the main executable
    makeWrapper $out/lib/ipfs-desktop/ipfs-desktop $out/bin/ipfs-desktop \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --set ELECTRON_IS_DEV 0 \
      --set ELECTRON_FORCE_IS_PACKAGED 1
    
    # Create desktop file
    cat > $out/share/applications/ipfs-desktop.desktop << EOF
    [Desktop Entry]
    Name=IPFS Desktop
    Comment=An unobtrusive and user-friendly desktop application for IPFS
    Exec=ipfs-desktop
    Icon=ipfs-desktop
    Terminal=false
    Type=Application
    Categories=Network;P2P;FileTransfer;
    Keywords=ipfs;p2p;distributed;web;dweb;
    StartupWMClass=IPFS Desktop
    MimeType=application/x-ipfs;
    EOF
    
    # Copy icon if available
    if [ -f "resources/app.asar.unpacked/assets/icon.png" ]; then
      cp resources/app.asar.unpacked/assets/icon.png $out/share/pixmaps/ipfs-desktop.png
    elif [ -f "assets/icon.png" ]; then
      cp assets/icon.png $out/share/pixmaps/ipfs-desktop.png
    else
      echo "Warning: No icon found for IPFS Desktop"
    fi
    
    runHook postInstall
  '';

  # Fix library paths
  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs})
  '';

  meta = with lib; {
    description = "An unobtrusive and user-friendly desktop application for IPFS on Windows, Mac and Linux";
    longDescription = ''
      IPFS Desktop is a desktop application for IPFS that allows you to
      run an IPFS node on your machine, giving you access to the distributed
      web and all the benefits of IPFS. It provides an unobtrusive and
      user-friendly interface for managing your IPFS node, file sharing,
      pinning, and distributed web browsing.
    '';
    homepage = "https://github.com/ipfs/ipfs-desktop";
    changelog = "https://github.com/ipfs/ipfs-desktop/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hi ];
    platforms = platforms.linux;
    mainProgram = "ipfs-desktop";
    broken = false;
  };
}
