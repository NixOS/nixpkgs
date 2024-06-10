{ lib
, stdenv
, dpkg
, autoPatchelfHook
, alsa-lib
, fetchurl
, at-spi2-core
, libtool
, libxkbcommon
, nspr
, mesa
, libtiff
, udev
, gtk3
, qtbase
, xorg
, cups
, pango
, runCommandLocal
, curl
, coreutils
, cacert
, libjpeg
, gtk2
, gdk-pixbuf
, libpulseaudio
, libbsd
, libusb1
, libmysqlclient
, llvmPackages
, dbus
, gcc-unwrapped
, libsForQt5
, freetype
, makeWrapper
, useChineseVersion ? false
, use365Version ? false
, oemIniFilePath ? ""
}:
let
  sources = import ./sources.nix;
  pkgVersion = if (useChineseVersion && use365Version) then sources.version else "11.1.0.11719";
  url =
    if (useChineseVersion && use365Version) then
      sources.url
    else if (useChineseVersion && !use365Version) then
      "https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/${lib.last (lib.splitVersion pkgVersion)}/wps-office_${pkgVersion}_amd64.deb"
    else
      "https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/${lib.last (lib.splitVersion pkgVersion)}/wps-office_${pkgVersion}.XA_amd64.deb";
  hash =
    if (useChineseVersion && use365Version) then
      sources.hash
    else if (useChineseVersion && !use365Version) then
      "sha256-LgE5du2ZnMsAqgoQkY63HWyWYA5TLS5I8ArRYrpxffs="
    else
      "sha256-6fXzHSMzZDGuBubOXsHA0YEUGKcy5QIPg3noyxUbdjA=";
  uri = builtins.replaceStrings [ "https://wps-linux-personal.wpscdn.cn" ] [ "" ] url;
  securityKey = "7f8faaaa468174dc1c9cd62e5f218a5b";
in
stdenv.mkDerivation rec {
  pname = "wpsoffice";
  version = pkgVersion;

  src =
    if (useChineseVersion && use365Version) then
      fetchurl { inherit url hash; }
    else
      runCommandLocal
        (if useChineseVersion then
          "wps-office_${version}_amd64.deb"
        else
          "wps-office_${version}.XA_amd64.deb")
        {
          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
          outputHash = hash;

          nativeBuildInputs = [ curl coreutils ];

          impureEnvVars = lib.fetchers.proxyImpureEnvVars;
          SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
        } ''
        timestamp10=$(date '+%s')
        md5hash=($(echo -n "${securityKey}${uri}$timestamp10" | md5sum))

        curl \
        --retry 3 --retry-delay 3 \
        "${url}?t=$timestamp10&k=$md5hash" \
        > $out
      '';

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
    qtbase
    xorg.libXdamage
    xorg.libXtst
    xorg.libXv

    # dependencies for 365 version
    gtk2
    gdk-pixbuf
    libpulseaudio
    xorg.libXScrnSaver
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

    # dependencies for 365 version
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
    # WPS 365 specific: file manager integration. Not needed
    "libnautilus-extension.so.1"
    "libcaja-extension.so.1"
    "libpeony.so.3"
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
    # WPS 365 specific
    if [ -f $out/opt/xiezuo/xiezuo ]; then
      # custom oem.ini if needed. Suitable for enterprise users
      if [ ! -z "${oemIniFilePath}" ]; then
        ln -sf "${oemIniFilePath}" $out/opt/kingsoft/wps-office/office6/cfgs/oem.ini
        ln -sf "${oemIniFilePath}" $out/opt/kingsoft/wps-office/office6/wtool/oem.ini
      fi
      # need system freetype and gcc lib to run properly
      for i in wps wpp et wpspdf wpsoffice; do
        wrapProgram $out/opt/kingsoft/wps-office/office6/$i \
          --set LD_PRELOAD "${freetype}/lib/libfreetype.so" \
          --set LD_LIBRARY_PATH "${lib.makeLibraryPath ([ gcc-unwrapped.lib ])}"
      done
    fi
    runHook postInstall
  '';

  preFixup = ''
    # The following libraries need libtiff.so.5, but nixpkgs provides libtiff.so.6
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/kingsoft/wps-office/office6/{libpdfmain.so,libqpdfpaint.so,qt/plugins/imageformats/libqtiff.so,addons/pdfbatchcompression/libpdfbatchcompressionapp.so}
    if [ -f $out/opt/kingsoft/wps-office/office6/addons/ksplitmerge/libksplitmergeapp.so ]; then
      patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/kingsoft/wps-office/office6/addons/ksplitmerge/libksplitmergeapp.so
    fi
    patchelf --add-needed libtiff.so $out/opt/kingsoft/wps-office/office6/libwpsmain.so
    # Fix: Wrong JPEG library version: library is 62, caller expects 80
    patchelf --add-needed libjpeg.so $out/opt/kingsoft/wps-office/office6/libwpsmain.so
    # dlopen dependency
    patchelf --add-needed libudev.so.1 $out/opt/kingsoft/wps-office/office6/addons/cef/libcef.so
    # WPS 365 specific: need libmysqlclient.so.18, but nixpkgs does not provide this
    if [ -f $out/opt/kingsoft/wps-office/office6/libFontWatermark.so ]; then
      patchelf --replace-needed libmysqlclient.so.18 libmysqlclient.so $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
      patchelf --add-rpath "${libmysqlclient}/lib/mariadb" $out/opt/kingsoft/wps-office/office6/libFontWatermark.so
    fi
    # WPS 365 specific: need libFcitxQt5DBusAddons.so.1, but nixpkgs does not provide this
    if [ -f $out/opt/xiezuo/resources/qt-tools/platforminputcontexts/libfcitxplatforminputcontextplugin.so ]; then
      patchelf --replace-needed libFcitxQt5DBusAddons.so.1 libFcitx5Qt5DBusAddons.so.1 $out/opt/xiezuo/resources/qt-tools/platforminputcontexts/libfcitxplatforminputcontextplugin.so
    fi
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Office suite, formerly Kingsoft Office";
    homepage = "https://www.wps.com";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    hydraPlatforms = [ ];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ mlatus th0rgal rewine pokon548 ];
  };
}
