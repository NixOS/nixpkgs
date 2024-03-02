{ lib
, stdenv
, fetchzip
, jre
, giflib
, gawk
, makeBinaryWrapper
, icoutils
, copyDesktopItems
, makeDesktopItem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maltego";
  version = "4.6.0";

  src = fetchzip {
    url = "https://downloads.maltego.com/maltego-v4/linux/Maltego.v${finalAttrs.version}.linux.zip";
    hash = "sha256-q+1RYToZtBxAIDSiUWf3i/3GBBDwh6NWteHiK4VM1HY=";
  };

  postPatch = ''
      substituteInPlace bin/maltego \
            --replace /usr/bin/awk ${lib.getExe gawk}
  '';

    desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Maltego";
      exec = finalAttrs.meta.mainProgram;
      icon = finalAttrs.pname;
      comment = "An open source intelligence and forensics application";
      categories = [ "Network" "Security" ];
      startupNotify = false;
    })
  ];

  nativeBuildInputs = [
    icoutils
    makeBinaryWrapper
    copyDesktopItems
  ];

  buildInputs = [ jre giflib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    chmod +x bin/maltego

    icotool -x bin/maltego.ico

    for size in 16 32 48 256
    do
      mkdir -p $out/share/icons/hicolor/$size\x$size/apps
      cp maltego_*_$size\x$size\x32.png $out/share/icons/hicolor/$size\x$size/apps/maltego.png
    done

    rm -r *.png

    cp -aR . "$out/share/maltego/"

    makeWrapper $out/share/maltego/bin/maltego $out/bin/${finalAttrs.meta.mainProgram} \
      --set JAVA_HOME ${jre} \
      --prefix PATH : ${lib.makeBinPath [ jre ]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.maltego.com";
    description = "An open source intelligence and forensics application, enabling to easily gather information about DNS, domains, IP addresses, websites, persons, and so on";
    mainProgram = "maltego";
    maintainers = with maintainers; [ emilytrau d3vil0p3r ];
    platforms = with platforms; linux ++ darwin;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
  };
})
