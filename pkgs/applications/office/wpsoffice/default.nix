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
, libxslt
, udev
, gtk3
, gdk-pixbuf
, qtbase
, xorg
, cups
, pango
, useChineseVersion ? false
}:

stdenv.mkDerivation rec {
  pname = "wpsoffice";
  version = "11.1.0.11698";

  src = if useChineseVersion then fetchurl {
    url = "https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/${lib.last (lib.splitString "." version)}/wps-office_${version}_amd64.deb";
    sha256 = "sha256-m7BOE2IF2m75mV/4X3HY9UJcidL0S0biqkidddp4LbQ=";
  } else fetchurl {
    url = "https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/${lib.last (lib.splitString "." version)}/wps-office_${version}.XA_amd64.deb";
    sha256 = "sha256-spqxQK/xTE8yFPmGbSbrDY1vSxkan2kwAWpCWIExhgs=";
  };

  unpackCmd = "dpkg -x $src .";
  sourceRoot = ".";

  postUnpack = ''
    # distribution is missing libkappessframework.so, so we should not let
    # autoPatchelfHook fail on the following dead libraries
    rm -r opt/kingsoft/wps-office/office6/addons/pdfbatchcompression

    # Remove the following libraries because they depend on qt4
    rm -r opt/kingsoft/wps-office/office6/{librpcetapi.so,librpcwpsapi.so,librpcwppapi.so,libavdevice.so.58.10.100,libmediacoder.so}
    rm -r opt/kingsoft/wps-office/office6/addons/wppcapturer/libwppcapturer.so
    rm -r opt/kingsoft/wps-office/office6/addons/wppencoder/libwppencoder.so
  '';

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
    libxslt
    udev
    gtk3
    gdk-pixbuf
    qtbase
    xorg.libXdamage
    xorg.libXtst
    xorg.libXrandr
    xorg.libXcomposite
    cups
    pango
  ];

  dontWrapQtApps = true;

  runtimeDependencies = map lib.getLib [
    cups
    pango
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
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/kingsoft/wps-office/office6/{libpdfmain.so,libqpdfpaint.so,qt/plugins/imageformats/libqtiff.so}
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
