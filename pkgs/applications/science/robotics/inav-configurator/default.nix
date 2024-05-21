{ lib, stdenv, fetchurl, makeDesktopItem, copyDesktopItems, nwjs, wrapGAppsHook3, gsettings-desktop-schemas, gtk3 }:

stdenv.mkDerivation rec {
  pname = "inav-configurator";
  version = "5.1.0";

  src = fetchurl {
    url = "https://github.com/iNavFlight/inav-configurator/releases/download/${version}/INAV-Configurator_linux64_${version}.tar.gz";
    sha256 = "sha256-ZvZxQICa5fnJBTx0aW/hqQCuhQW9MkcVa2sOjPYaPXM=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/iNavFlight/inav-configurator/bf3fc89e6df51ecb83a386cd000eebf16859879e/images/inav_icon_128.png";
    sha256 = "1i844dzzc5s5cr4vfpi6k2kdn8jiqq2n6c0fjqvsp4wdidwjahzw";
  };

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook3 ];

  buildInputs = [ gsettings-desktop-schemas gtk3 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin \
             $out/opt/${pname}

    cp -r inav-configurator $out/opt/inav-configurator/
    install -m 444 -D $icon $out/share/icons/hicolor/128x128/apps/${pname}.png

    chmod +x $out/opt/inav-configurator/inav-configurator
    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} --add-flags $out/opt/inav-configurator/inav-configurator

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "iNavFlight configuration tool";
    desktopName = "iNav Configurator";
    genericName = "Flight controller configuration tool";
  };

  meta = with lib; {
    description = "The iNav flight control system configuration tool";
    mainProgram = "inav-configurator";
    longDescription = ''
      A crossplatform configuration tool for the iNav flight control system.
      Various types of aircraft are supported by the tool and by iNav, e.g.
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage = "https://github.com/iNavFlight/inav/wiki";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tilcreator wucke13 ];
    platforms = platforms.linux;
  };
}
