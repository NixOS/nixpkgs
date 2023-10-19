{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, alsa-lib
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
, useChineseVersion ? false
}:

stdenv.mkDerivation rec {
  pname = "wpsoffice";
  version = "11.1.0.11704";

  src = if useChineseVersion then fetchurl {
    url = "https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/${lib.last (lib.splitString "." version)}/wps-office_${version}_amd64.deb";
    hash = "sha256-ffLSon9FpQZDQ1uapchBUkVaHOXs+H/6kHJLNiWqwiE=";
  } else fetchurl {
    url = "https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/${lib.last (lib.splitString "." version)}/wps-office_${version}.XA_amd64.deb";
    hash = "sha256-nxpMEWKiNjjEUoVJkhpvjnCuWBCCGjPk+sUlKz+KjMI=";
  };

  unpackCmd = "dpkg -x $src .";
  sourceRoot = ".";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    libtool
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
  ];

  dontWrapQtApps = true;

  runtimeDependencies = map lib.getLib [
    cups
    pango
  ];

  autoPatchelfIgnoreMissingDeps = [
    # distribution is missing libkappessframework.so
    "libkappessframework.so"
    # qt4 support is deprecated
    "libQtCore.so.4"
    "libQtNetwork.so.4"
    "libQtXml.so.4"
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
    runHook postInstall
  '';

  preFixup = ''
    # The following libraries need libtiff.so.5, but nixpkgs provides libtiff.so.6
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/kingsoft/wps-office/office6/{libpdfmain.so,libqpdfpaint.so,qt/plugins/imageformats/libqtiff.so,addons/pdfbatchcompression/libpdfbatchcompressionapp.so}
    # dlopen dependency
    patchelf --add-needed libudev.so.1 $out/opt/kingsoft/wps-office/office6/addons/cef/libcef.so
  '';

  meta = with lib; {
    description = "Office suite, formerly Kingsoft Office";
    homepage = "https://www.wps.com";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    hydraPlatforms = [ ];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ mlatus th0rgal rewine ];
  };
}
