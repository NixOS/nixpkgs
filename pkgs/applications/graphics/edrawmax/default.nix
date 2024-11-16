{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  cups,
  e2fsprogs,
  freetype,
  gcc-unwrapped,
  glib,
  gtk3,
  krb5,
  libmysqlclient,
  libsForQt5,
  mesa,
  pango,
  postgresql,
  udev,
  xkeyboardconfig,
  xorg,
  useChineseVersion ? false,
}:

stdenv.mkDerivation {
  pname = "edrawmax";
  version = "14.0.0";
  src = fetchurl {
    url =
      if useChineseVersion then
        "https://cc-download.wondershare.cc/prd/edrawmax_full5374.deb"
      else
        "https://download.wondershare.com/prd/edrawmax_full5371.deb";
    hash =
      if useChineseVersion then
        "sha256-s5oQd6KWI3zZmqXWDFVdsZzqycOwj7BIEVd8pCCovL0="
      else
        "sha256-mmlCiVNa5ZLoTbOKvakNu2+wF2/CJMzcAFoITI3B0ok=";
  };

  unpackCmd = "dpkg -x $src .";
  sourceRoot = ".";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    cups
    e2fsprogs
    glib
    gtk3
    krb5
    libsForQt5.qt5.qt3d
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtgamepad
    libsForQt5.qt5.qtsensors
    libsForQt5.qt5.qtserialport
    libsForQt5.qt5.qttools
    libsForQt5.qt5.qtwebengine
    libmysqlclient
    mesa
    pango
    postgresql
    udev
    xorg.libxshmfence
  ];

  dontWrapQtApps = true;

  runtimeDependencies = map lib.getLib ([
    cups
    pango
    freetype
    gcc-unwrapped.lib
  ]);

  installPhase = ''
    runHook preInstall
    prefix=$out/opt/apps/edrawmax
    mkdir -p $out
    cp -r opt $out
    cp -r usr/* $out
    makeWrapper $prefix/EdrawMax $out/bin/EdrawMax \
      --set QT_QPA_PLATFORM "" \
      --set QT_XKB_CONFIG_ROOT "${xkeyboardconfig}/share/X11/xkb"
    substituteInPlace $out/share/applications/edrawmax.desktop \
      --replace "sh /opt/apps/edrawmax/edrawmax.sh" $out/bin/EdrawMax
    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libudev.so.1 $out/opt/apps/edrawmax/lib/libcef.so
    patchelf --replace-needed libmysqlclient.so.18 libmysqlclient.so $out/opt/apps/edrawmax/lib/sqldrivers/libqsqlmysql.so
    patchelf --add-rpath "${libmysqlclient}/lib/mariadb" $out/opt/apps/edrawmax/lib/sqldrivers/libqsqlmysql.so
  '';

  meta = {
    description = "All-in-One Diagram Software";
    homepage = "https://www.edrawsoft.com/edraw-max/";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ ltrump ];
  };
}
