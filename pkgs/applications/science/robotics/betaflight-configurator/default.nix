{stdenv, fetchurl, unzip, makeDesktopItem, nwjs, wrapGAppsHook, gsettings-desktop-schemas, gtk3 }:

let
  strippedName = "betaflight-configurator";
  desktopItem = makeDesktopItem {
    name = strippedName;
    exec = strippedName;
    icon = "${strippedName}-icon.png";
    comment = "Betaflight configuration tool";
    desktopName = "Betaflight Configurator";
    genericName = "Flight controller configuration tool";
  };
in
stdenv.mkDerivation rec {
  name = "${strippedName}-${version}";
  version = "10.5.1";
  src = fetchurl {
    url = "https://github.com/betaflight/betaflight-configurator/releases/download/${version}/${strippedName}_${version}_linux64.zip";
    sha256 = "1l4blqgaqfrnydk05q6pwdqdhcly2f8nwzrv0749cqmfiinh8ygc";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  
  buildInputs = [ unzip gsettings-desktop-schemas gtk3 ];
  
  installPhase = ''
    mkdir -p $out/bin \
             $out/opt/${strippedName} \
             $out/share/icons

    cp -r . $out/opt/${strippedName}/
    cp icon/*_icon_128.png $out/share/icons/${strippedName}-icon.png
    cp -r ${desktopItem}/share/applications $out/share/

    makeWrapper ${nwjs}/bin/nw $out/bin/${strippedName} --add-flags $out/opt/${strippedName}
  '';

  meta = with stdenv.lib; {
    description = "The Betaflight flight control system configuration tool";
    longDescription = ''
      A crossplatform configuration tool for the Betaflight flight control system.
      Various types of aircraft are supported by the tool and by Betaflight, e.g. 
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage    = https://github.com/betaflight/betaflight/wiki;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ wucke13 ];
    platforms   = platforms.linux;
  };
}
