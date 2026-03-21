{
  autoPatchelfHook,
  makeDesktopItem,
  lib,
  stdenv,
  wrapGAppsHook3,
  fetchurl,
  copyDesktopItems,
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
  libcxx,
  libdrm,
  libnotify,
  libpulseaudio,
  libuuid,
  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libxcb,
  libxshmfence,
  libgbm,
  nspr,
  nss,
  pango,
  systemd,
  libappindicator-gtk3,
  libdbusmenu,
}:

stdenv.mkDerivation rec {
  pname = "premid";
  version = "2.3.4";

  src = fetchurl {
    url = "https://github.com/premid/Linux/releases/download/v${version}/${pname}.tar.gz";
    sha256 = "sha256-ime6SCxm+fhMR2wagv1RItqwLjPxvJnVziW3DZafP50=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    cups
    libdrm
    libuuid
    libxdamage
    libx11
    libxscrnsaver
    libxtst
    libxcb
    libxshmfence
    libgbm
    nss
  ];

  dontWrapGApps = true;
  dontBuild = true;
  dontConfigure = true;

  libPath = lib.makeLibraryPath [
    libcxx
    systemd
    libpulseaudio
    libdrm
    libgbm
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
    libnotify
    libx11
    libxcomposite
    libuuid
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    nspr
    nss
    libxcb
    pango
    systemd
    libxscrnsaver
    libappindicator-gtk3
    libdbusmenu
  ];

  installPhase = ''
    mkdir -p $out/{bin,opt/PreMiD,share/pixmaps}
    mv * $out/opt/PreMiD

    chmod +x $out/opt/PreMiD/${pname}
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
        $out/opt/PreMiD/${pname}

    wrapProgram $out/opt/PreMiD/${pname} \
        "''${gappsWrapperArgs[@]}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/${pname}

    ln -s $out/opt/PreMiD/${pname} $out/bin/
  '';

  # This is the icon used by the desktop file
  postInstall = ''
    ln -s $out/opt/PreMiD/assets/appIcon.png $out/share/pixmaps/${pname}.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "PreMiD";
      icon = pname;
      desktopName = "PreMiD";
      genericName = meta.description;
      mimeTypes = [ "x-scheme-handler/premid" ];
    })
  ];

  meta = {
    description = "Simple, configurable utility to show your web activity as playing status on Discord";
    homepage = "https://premid.app";
    downloadPage = "https://premid.app/downloads";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ natto1784 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "premid";
  };
}
