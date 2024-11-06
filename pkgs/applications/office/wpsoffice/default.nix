{
  lib,
  stdenv,
  dpkg,
  autoPatchelfHook,
  alsa-lib,
  at-spi2-core,
  libtool,
  libxkbcommon,
  nspr,
  mesa,
  libtiff,
  udev,
  gtk3,
  libsForQt5,
  xorg,
  cups,
  pango,
  libjpeg,
  gtk2,
  gdk-pixbuf,
  libpulseaudio,
  libbsd,
  libusb1,
  libmysqlclient,
  llvmPackages,
  dbus,
  gcc-unwrapped,
  freetype,
  curl,
  makeWrapper,
  runCommandLocal,
  cacert,
  coreutils,
  fetchurl,
  useChineseVersion ? false,
  use365Version ? false,
}:
let
  sources = import ./sources.nix;
  pkgVersion = "12.1.0.17900";
  url =
    if useChineseVersion then
      "https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2023/${lib.last (lib.splitVersion pkgVersion)}/wps-office_${pkgVersion}_amd64.deb"
    else
      "https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/${lib.last (lib.splitVersion pkgVersion)}/wps-office_${pkgVersion}.XA_amd64.deb";
  hash =
    if useChineseVersion then
      "sha256-i2EVCmDLE2gx7l2aAo+fW8onP/z+xlPIbQYwKhQ46+o="
    else
      "sha256-o8njvwE/UsQpPuLyChxGAZ4euvwfuaHxs5pfUvcM7kI=";
  uri = builtins.replaceStrings [ "https://wps-linux-personal.wpscdn.cn" ] [ "" ] url;
  securityKey = "7f8faaaa468174dc1c9cd62e5f218a5b";
in
stdenv.mkDerivation rec {
  pname = "wpsoffice";
  version = if use365Version then sources.version else pkgVersion;

  src =
    if use365Version then
      (
        {
          x86_64-linux = fetchurl {
            url = sources.pro_amd64_url;
            hash = sources.pro_amd64_hash;
          };
          aarch64-linux = fetchurl {
            url = sources.pro_arm64_url;
            hash = sources.pro_arm64_hash;
          };
        }
        .${stdenv.system} or (throw "wpsoffice-365-${version}: ${stdenv.system} is unsupported.")
      )
    else if (stdenv.system == "x86_64-linux") then
      runCommandLocal
        (
          if useChineseVersion then
            "wps-office_${version}_amd64.deb"
          else
            "wps-office_${version}.XA_amd64.deb"
        )
        {
          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
          outputHash = hash;

          nativeBuildInputs = [
            curl
            coreutils
          ];

          impureEnvVars = lib.fetchers.proxyImpureEnvVars;
          SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
        }
        ''
          timestamp10=$(date '+%s')
          md5hash=($(echo -n "${securityKey}${uri}$timestamp10" | md5sum))

          curl \
          --retry 3 --retry-delay 3 \
          "${url}?t=$timestamp10&k=$md5hash" \
          > $out
        ''
    else
      (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

  unpackCmd = "dpkg -x $src .";
  sourceRoot = ".";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    libtool
    libjpeg
    libxkbcommon
    nspr
    mesa
    libtiff
    udev
    gtk3
    libsForQt5.qt5.qtbase
    xorg.libXdamage
    xorg.libXtst
    xorg.libXv
    gtk2
    gdk-pixbuf
    libpulseaudio
    xorg.libXScrnSaver
    xorg.libXxf86vm
    libbsd
    libusb1
    libmysqlclient
    llvmPackages.openmp
    dbus
    libsForQt5.fcitx5-qt
  ];

  dontWrapQtApps = true;

  runtimeDependencies = map lib.getLib [
    cups
    pango
    freetype
    gcc-unwrapped.lib
  ];

  autoPatchelfIgnoreMissingDeps = [
    # distribution is missing libkappessframework.so
    "libkappessframework.so"
    # qt4 support is deprecated
    "libQtCore.so.4"
    "libQtNetwork.so.4"
    "libQtXml.so.4"
    # file manager integration. Not needed
    "libnautilus-extension.so.1"
    "libcaja-extension.so.1"
    "libpeony.so.3"
    # libuof.so is a exclusive library in WPS. No need to repatch it
    "libuof.so"
  ];

  installPhase = ''
    runHook preInstall
    prefix=$out/opt/kingsoft/wps-office
    mkdir -p $out
    cp -r opt $out
    cp -r usr/* $out
    for i in wps wpp et wpspdf; do
      substituteInPlace $out/bin/$i \
        --replace /opt/kingsoft/wps-office $prefix
    done
    for i in $out/share/applications/*;do
      substituteInPlace $i \
        --replace /usr/bin $out/bin
    done
    # need system freetype and gcc lib to run properly
    for i in wps wpp et wpspdf wpsoffice; do
      wrapProgram $out/opt/kingsoft/wps-office/office6/$i \
        --set LD_PRELOAD "${freetype}/lib/libfreetype.so" \
        --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ gcc-unwrapped.lib ]}"
    done
    runHook postInstall
  '';

  preFixup = ''
    # The following libraries need libtiff.so.5, but nixpkgs provides libtiff.so.6
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/kingsoft/wps-office/office6/{libpdfmain.so,libqpdfpaint.so,qt/plugins/imageformats/libqtiff.so,addons/pdfbatchcompression/libpdfbatchcompressionapp.so}
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/kingsoft/wps-office/office6/addons/ksplitmerge/libksplitmergeapp.so
    patchelf --add-needed libtiff.so $out/opt/kingsoft/wps-office/office6/libwpsmain.so
    # Fix: Wrong JPEG library version: library is 62, caller expects 80
    patchelf --add-needed libjpeg.so $out/opt/kingsoft/wps-office/office6/libwpsmain.so
    # dlopen dependency
    patchelf --add-needed libudev.so.1 $out/opt/kingsoft/wps-office/office6/addons/cef/libcef.so
    # 365 specific: Font watermark
    if [ -e $out/opt/kingsoft/wps-office/office6/libFontWatermark.so ]; then
      patchelf --replace-needed libmysqlclient.so.18 libmysqlclient.so $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
      patchelf --add-rpath "${libmysqlclient}/lib/mariadb" $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
    fi
    # 365 specific: xiezuo
    if [ -e $out/opt/xiezuo/resources/qt-tools/platforminputcontexts/libfcitxplatforminputcontextplugin.so ]; then
      patchelf --replace-needed libFcitxQt5DBusAddons.so.1 libFcitx5Qt5DBusAddons.so.1 $out/opt/xiezuo/resources/qt-tools/platforminputcontexts/libfcitxplatforminputcontextplugin.so
    fi
  '';

  meta = with lib; {
    description = "Office suite, formerly Kingsoft Office";
    homepage = "https://www.wps.com";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    hydraPlatforms = [ ];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [
      mlatus
      th0rgal
      rewine
      pokon548
    ];
  };
}
