{
  fetchurl,
  lib,
  stdenv,
  squashfsTools,
  xorg,
  alsa-lib,
  freetype,
  glib,
  pango,
  cairo,
  atk,
  gdk-pixbuf,
  gtk3,
  cups,
  nspr,
  nss_latest,
  libpng,
  libnotify,
  libgcrypt,
  systemd,
  fontconfig,
  dbus,
  expat,
  curlWithGnuTls,
  zlib,
  at-spi2-atk,
  at-spi2-core,
  libdrm,
  libgbm,
  libxkbcommon,
  harfbuzz,
  libsecret,
  buildFHSEnv,
}:

let
  # determine these versions from
  # curl -H 'Snap-Device-Series: 16' http://api.snapcraft.io/v2/snaps/info/nordpass
  version = "5.23.13";
  snapVersion = "192";
  snapId = "00CQ2MvSr0Ex7zwdGhCYTa0ZLMw3H6hf";
  snapBaseUrl = "https://api.snapcraft.io/api/v1/snaps/download/";

  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curlWithGnuTls
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libdrm
    libgcrypt
    libnotify
    libpng
    libsecret
    libxkbcommon
    libgbm
    nspr
    nss_latest
    pango
    stdenv.cc.cc
    systemd
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libxshmfence
    xorg.libXtst
    zlib
  ];

  thisPackage = stdenv.mkDerivation {
    pname = "nordpass";

    inherit version;

    src = fetchurl {
      url = "${snapBaseUrl}${snapId}_${snapVersion}.snap";
      hash = "sha256-teqeeLzqLVL/l5WsTXlRj3GM0YMHm+Z2MWy4GE8s7k8=";
    };

    nativeBuildInputs = [ squashfsTools ];

    dontStrip = true;
    dontPatchELF = true;

    unpackPhase = ''
      runHook preUnpack
      unsquashfs "$src"
      cd squashfs-root
      runHook postUnpack
    '';

    # Prevent double wrapping
    dontWrapGApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/opt/nordpass"
      cp -r . "$out/opt/nordpass/"

      mkdir -p $out/bin
      ln -s "$out/opt/nordpass/nordpass" "$out/bin/nordpass"

      # Desktop file
      mkdir -p "$out/share/applications/"
      cp "$out/opt/nordpass/meta/gui/nordpass.desktop" "$out/share/applications/"
      # Icon
      mkdir -p "$out/share/icons/hicolor/512x512/apps"
      cp "$out/opt/nordpass/meta/gui/icon.png" \
        "$out/share/icons/hicolor/512x512/apps/nordpass.png"

      sed -i -e "s#^Icon=.*\$#Icon=$out/share/icons/hicolor/512x512/apps/nordpass.png#" \
        "$out/share/applications/nordpass.desktop"

      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://nordpass.com/";
      description = "Secure and simple password manager for a stress-free online experience";
      license = licenses.unfree;
      mainProgram = "nordpass";
      maintainers = with maintainers; [ coconnor ];
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    };
  };
in

buildFHSEnv {
  name = "nordpass";
  targetPkgs = _: deps ++ [ thisPackage ];
  runScript = "nordpass";

  extraInstallCommands = ''
    mkdir -p "$out/share"
    cp -r ${thisPackage}/share/* "$out/share/"
  '';

  inherit (thisPackage) meta;
}
