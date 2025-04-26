{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook3,
  flac,
  gnome2,
  harfbuzzFull,
  nss,
  snappy,
  xdg-utils,
  xorg,
  alsa-lib,
  atk,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libX11,
  libxcb,
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
  libdrm,
  libnotify,
  libopus,
  libpulseaudio,
  libuuid,
  libxshmfence,
  mesa,
  nspr,
  pango,
  systemd,
  at-spi2-atk,
  at-spi2-core,
  libqt5pas,
  qt6,
  vivaldi-ffmpeg-codecs
}:

stdenv.mkDerivation rec {
  pname = "slimjet";
  version = "45.0.3.0";
  fullName = "flashpeak-slimjet";

  suffix =
    if stdenv.isx86_64 then
      "amd64"
    else if stdenv.isx86_32 then
      "i386"
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";
  src = fetchurl {
    url = "http://www.slimjetbrowser.com/release/archive/${version}/slimjet_${suffix}.deb";
    hash = "sha256-RtDN2NXONfjHbnMC4Mk9fAwA4xrmfq3H9D/eFuazklY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    flac
    harfbuzzFull
    nss
    snappy
    xdg-utils
    xorg.libxkbfile
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig.lib
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
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
    libdrm
    libnotify
    libopus
    libuuid
    libxcb
    libxshmfence
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    libqt5pas
    qt6.qtbase
  ];

  unpackPhase = ''
    ar vx $src
    tar -xvf data.tar.xz
  '';

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp {usr/share,opt} $out/ -R
    mkdir "$out/bin"
    substituteInPlace "$out"/share/applications/*.desktop --replace-fail /usr/bin/ "$out"/bin/
    substituteInPlace "$out"/share/menu/${pname}.menu --replace-fail /opt/ $out/opt/ --replace-fail /usr/ $out/usr/
    substituteInPlace "$out"/share/gnome-control-center/default-apps/${pname}.xml --replace-fail /opt/ $out/opt/
    ln -sf ${vivaldi-ffmpeg-codecs}/lib/libffmpeg.so "$out"/opt/${pname}/libffmpeg.so
    for f in ${fullName} ${pname} ${pname}-sandbox; do
      ln -sf "$out"/opt/${pname}/$f "$out"/bin/$f
    done
    runHook postInstall
  '';

  runtimeDependencies = map lib.getLib [
    libpulseaudio
    curl
    systemd
    vivaldi-ffmpeg-codecs
  ] ++ buildInputs;

  meta = with lib; {
    description = "Flashpeak Slimjet; fastest web browser that automatically blocks ads";
    homepage = "https://www.slimjet.com/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ mmad ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
