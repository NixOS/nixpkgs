{
  lib,
  autoPatchelfHook,
  stdenv,
  dpkg,
  fetchurl,

  cups,
  dbus,
  eglexternalplatform,
  egl-gbm,
  egl-wayland,
  egl-x11,
  fontconfig,
  freetype,
  gcc,
  gfortran,
  glib,
  krb5,
  libgcc,
  libGL,
  libGLU,
  libGLX,
  libkrb5,
  libtinfo,
  libuuid,
  libx11,
  libxcb,
  libxcb-cursor,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-util,
  libxcb-wm,
  libxkbcommon,
  libz,
  ncurses,
  openssl_3_5,
  python311,
  qt6,
  sqlite,
  xz,
}:
stdenv.mkDerivation rec {
  pname = "mnova";

  version = "17.0.0-41178";

  src = fetchurl {
    url = "https://mestrelab.com/downloads/mnova/linux/Debian/13/mestrenova_${version}_amd64.deb";
    hash = "sha256-d8UQjiaxbtYNrwYPTF97gOV2MaRvt9B9Q4AI5oDlz/E=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland

    cups
    dbus
    eglexternalplatform
    egl-gbm
    egl-wayland
    egl-x11
    fontconfig
    freetype
    gcc
    gfortran.cc
    glib
    krb5.lib
    libgcc
    libGL
    libGLU
    libGLX
    libkrb5
    libtinfo
    libuuid
    libx11
    libxcb
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-util
    libxcb-wm
    libxkbcommon
    libz
    ncurses
    openssl_3_5
    python311
    python311
    sqlite
    xz
  ];

  nativeBuildInputs = [
    dpkg
    qt6.wrapQtAppsHook
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    dpkg -x $src $out
    mv $out/opt/MestReNova/* $out

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    substituteInPlace $out/share/applications/*.desktop \
      --replace-fail '/opt/MestReNova/bin/MestReNova' "$out/bin/MestReNova"

    runHook postFixup
  '';

  meta = {
    description = "MestReNova is a multivendor software suite designed for combined NMR, LC/GC/MS and Electronic & Vibrational Spectroscopic techniques.";
    homepage = "https://mestrelab.com/main-product/mnova";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      hideyosh1
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "MestReNova";
  };
}
