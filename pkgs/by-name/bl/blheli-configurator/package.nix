{ lib, stdenv, fetchurl, unzip, makeDesktopItem, copyDesktopItems, nwjs084, wrapGAppsHook3, gsettings-desktop-schemas, gtk3 }:

stdenv.mkDerivation rec {
  pname = "blheli-configurator";
  version = "1.2.0";
  src = fetchurl {
    url = "https://github.com/blheli-configurator/blheli-configurator/releases/download/${version}/BLHeli-Configurator_linux64_${version}.zip";
    hash = "sha256-apsBkROv2JATEOfpT7Pjr2N+idK2EJpKRQFRLJzs3tM=";
  };

  # remove large unneeded files
  postUnpack = ''
    find -name "lib*.so" -delete
    find -name "lib*.so.*" -delete
  '';

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook3 unzip ];

  buildInputs = [ gsettings-desktop-schemas gtk3 ];

  installPhase = let
    icon = fetchurl {
      url = "https://raw.githubusercontent.com/blheli-configurator/blheli-configurator/1.2.0/images/icon_128.png";
      hash = "sha256-D4BgVAU89Nu2IE7dZFf4aKU+iHEEf1sMxZ5+gUmUsYI=";
    };
  in ''
    runHook preInstall
    mkdir -p $out/bin \
             $out/opt/${pname}

    cp -r . $out/opt/${pname}/
    install -m 444 -D ${icon} $out/share/icons/hicolor/128x128/apps/${pname}.png

    makeWrapper ${nwjs084}/bin/nw $out/bin/${pname} \
                --add-flags $out/opt/${pname}/${pname}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      comment = "BLHeli configuration tool";
      desktopName = "BLHeli Configurator";
      genericName = "BLHeli ESC configuration tool";
    })
  ];

  meta = with lib; {
    description = "An application for flashing and configuration of BLHeli firmware";
    mainProgram = "blheli-configurator";
    homepage = "https://github.com/blheli-configurator/blheli-configurator";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    license = licenses.gpl3;
    maintainers = [ maintainers.ilya-epifanov ];
    platforms = [ "x86_64-linux" ];
  };
}
