{ lib, stdenv, fetchurl, makeDesktopItem, copyDesktopItems, nwjs, wrapGAppsHook3, gsettings-desktop-schemas, version, hash, packed ? false }:

let
  shortVersion = lib.versions.major version;
  bin_name = "inav-configurator";
in
stdenv.mkDerivation rec {
  pname = "${bin_name}-" + shortVersion;
  inherit version;

  src = fetchurl {
    url = "https://github.com/iNavFlight/inav-configurator/releases/download/${version}/INAV-Configurator_linux64_${version}.tar.gz";
    inherit hash;
  };

  postUnpack = ''
    find -name "lib*.so" -delete
    find -name "lib*.so.*" -delete
  '';

  nativeBuildInputs = [ copyDesktopItems wrapGAppsHook3 ];

  buildInputs = [ gsettings-desktop-schemas ];

  installPhase = let
    icon = fetchurl {
      url = "https://raw.githubusercontent.com/iNavFlight/inav-configurator/bf3fc89e6df51ecb83a386cd000eebf16859879e/images/inav_icon_128.png";
      hash = "sha256-/EMleYuNk6s3lg4wYwXGUSLbppgmXrdJZkUX9n8jBMU=";
    };
  in ''
    runHook preInstall

    mkdir -p $out/bin \
             $out/opt/${pname}

    cp -r * $out/opt/${pname}/
    install -m 444 -D ${icon} $out/share/icons/hicolor/128x128/apps/${pname}.png

    chmod +x $out/opt/${pname}/inav-configurator
    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} \
                --add-flags $out/opt/${pname}${if packed then "/${bin_name}" else ""}

    runHook postInstall
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "INAV configuration tool " + version;
    desktopName = "INAV Configurator " + version;
    genericName = "Flight controller configuration tool";
  };

  meta = {
    description = "The INAV flight control system configuration tool";
    mainProgram = pname;
    longDescription = ''
      A crossplatform configuration tool for the INAV flight control system.
      Various types of aircraft are supported by the tool and by INAV, e.g.
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage = "https://github.com/iNavFlight/inav/wiki";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tilcreator wucke13 ilya-epifanov ];
    platforms = lib.platforms.linux;
  };
}
