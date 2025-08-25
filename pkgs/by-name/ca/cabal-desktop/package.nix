{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fontconfig,
  gcc-unwrapped,
  gdk-pixbuf,
  gsettings-desktop-schemas,
  gtk3,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libappindicator-gtk3,
  libcap,
  libdrm,
  libgnome-keyring,
  libgpg-error,
  libnotify,
  libsodium,
  libudev0-shim,
  libuuid,
  libxcb,
  libxshmfence,
  makeWrapper,
  mesa,
  nspr,
  nss,
  pango,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cabal-desktop";
  version = "8.0.0";

  src = fetchurl {
    url = "https://github.com/cabal-club/cabal-desktop/releases/download/v${finalAttrs.version}/cabal-desktop_${finalAttrs.version}_amd64.deb";
    hash = "sha256-ajalBzJ1biMu7sF0rLm8gnftPz3SFv8otGptDICaxXc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
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
    gcc-unwrapped
    gdk-pixbuf
    gsettings-desktop-schemas
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libappindicator-gtk3
    libcap
    libdrm
    libgnome-keyring
    libgpg-error
    libnotify
    libsodium
    libudev0-shim
    libuuid
    libxcb
    libxshmfence
    mesa
    nspr
    nss
    pango
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/cabal-desktop $out/bin $out/lib
    mv opt/Cabal/* $out/share/cabal-desktop
    mv usr/share/* $out/share/
    ln -s $out/share/cabal-desktop/cabal-desktop $out/bin/cabal-desktop
    runHook preInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libudev0-shim
        gcc-unwrapped
      ]
    })
    # Correct desktop file `Exec`
    substituteInPlace $out/share/applications/cabal-desktop.desktop \
      --replace-fail "/opt/Cabal/cabal-desktop" "$out/bin/cabal-desktop"
  '';

  meta = {
    homepage = "https://cabal.chat";
    changelog = "https://github.com/cabal-club/cabal-desktop/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Desktop client for cabal, the p2p/decentralized/offline-first chat platform";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.dansbandit ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
