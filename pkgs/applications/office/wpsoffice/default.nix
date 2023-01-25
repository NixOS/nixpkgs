{ lib
, stdenv
, mkDerivation
, fetchurl
, dpkg
, wrapGAppsHook
, wrapQtAppsHook
, autoPatchelfHook
, alsa-lib
, libtool
, nspr
, mesa
, libtiff
, cups
, xorg
, steam-run
, makeWrapper
, useChineseVersion ? false
}:

stdenv.mkDerivation rec {
  pname = "wpsoffice";
  version = "11.1.0.11664";

  src = if useChineseVersion then fetchurl {
    url = "https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/${lib.last (lib.splitString "." version)}/wps-office_${version}_amd64.deb";
    sha256 = "sha256-D2LhxBMHmQjVExa/63DHdws0V+EmOSlJzGq91jbuJHs=";
  } else fetchurl {
    url = "http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/${lib.last (lib.splitString "." version)}/wps-office_${version}.XA_amd64.deb";
    sha256 = "sha256-9qZGqs4nsB9mWCJTi2x+vWmMF0sEoUYgEzLI//hijfU=";
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

  nativeBuildInputs = [ dpkg wrapGAppsHook wrapQtAppsHook makeWrapper autoPatchelfHook ];

  buildInputs = [
    alsa-lib
    xorg.libXdamage
    xorg.libXtst
    libtool
    nspr
    mesa
    libtiff
    cups.lib
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
    for i in wps wpp et wpspdf; do
      mv $out/bin/$i $out/bin/.$i-orig
      makeWrapper ${steam-run}/bin/steam-run $out/bin/$i \
        --add-flags $out/bin/.$i-orig \
        --argv0 $i
    done
    runHook postInstall
  '';

  dontWrapQtApps = true;
  dontWrapGApps = true;

  preFixup = ''
    # The following libraries need libtiff.so.5, but nixpkgs provides libtiff.so.6
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/kingsoft/wps-office/office6/{libpdfmain.so,libqpdfpaint.so,qt/plugins/imageformats/libqtiff.so}
  '';

  postFixup = ''
    for f in "$out"/bin/*; do
      echo "Wrapping $f"
      wrapProgram "$f" \
        "''${gappsWrapperArgs[@]}" \
        "''${qtWrapperArgs[@]}"
    done
  '';

  meta = with lib; {
    description = "Office suite, formerly Kingsoft Office";
    homepage = "https://www.wps.com";
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ mlatus th0rgal rewine ];
  };
}
