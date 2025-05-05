{
  lib,
  stdenv,
  requireFile,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  alsa-lib,
  atk,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libcxx,
  libdrm,
  libnotify,
  libpulseaudio,
  libuuid,
  libX11,
  libxcb,
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
  libgbm,
  nspr,
  nss,
  openssl,
  pango,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "upwork";
  version = "5.8.0.35";

  src = requireFile {
    name = "${pname}_${version}_amd64.deb";
    url = "https://www.upwork.com/ab/downloads/os/linux/";
    sha256 = "sha256-Suv23TL6l5HhkOSRT56LpFRZJxuSLYVc1uT6he8j7O0=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    libcxx
    systemd
    libpulseaudio
    stdenv.cc.cc
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
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
    libuuid
    libX11
    libxcb
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXScrnSaver
    libXtst
    libgbm
    nspr
    nss
    pango
    systemd
  ];

  libPath = lib.makeLibraryPath buildInputs;

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv opt $out

    # Now it requires lib{ssl,crypto}.so.1.0.0. Fix based on Spotify pkg.
    # https://github.com/NixOS/nixpkgs/blob/efea022d6fe0da84aa6613d4ddeafb80de713457/pkgs/applications/audio/spotify/default.nix#L129
    mkdir -p $out/lib/upwork
    ln -s ${lib.getLib openssl}/lib/libssl.so $out/lib/upwork/libssl.so.1.0.0
    ln -s ${lib.getLib openssl}/lib/libcrypto.so $out/lib/upwork/libcrypto.so.1.0.0

    sed -e "s|/opt/Upwork|$out/bin|g" -i $out/share/applications/upwork.desktop
    makeWrapper $out/opt/Upwork/upwork \
      $out/bin/upwork \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --prefix LD_LIBRARY_PATH : ${libPath}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Online freelancing platform desktop application for time tracking";
    homepage = "https://www.upwork.com/ab/downloads/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zakkor ];
  };
}
