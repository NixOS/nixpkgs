{ lib, stdenv, fetchurl, unzip, makeDesktopItem, openjdk17 }:

let
  desktopItem = makeDesktopItem {
    name = "tapaal";
    exec = "tapaal";
    icon = "tapaal";
    desktopName = "TAPAAL";
    comment = "Tool for editing, simulation and verification of P/T and timed-arc Petri Nets.";
    categories = [ "Science" "ComputerScience" ];
  };

  icon = fetchurl {
    url = "https://www.tapaal.net/images/tapaal.png";
    sha256 = "c25b1a2dd773692e4cf4c13c2e78ac30245cb2389bda7bc886361f7a263a7a57";
  };

in stdenv.mkDerivation rec {
  pname = "tapaal";
  version = "3.9.3";

  src = fetchurl {
    url = "https://download.tapaal.net/tapaal/tapaal-3.9/${pname}-${version}-linux64.zip";
    sha256 = "234a8cd500420235a330349d38099643a774ed375ee96cb0552d3236c2a92b6f";
  };

  nativeBuildInputs = [ unzip ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt
    mkdir -p $out/share/doc
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/60x60/apps/

    cp -r bin lib $out/opt
    cp LICENSE.txt README.txt $out/share/doc

    # Create wrapper script:
    echo "#!/bin/sh" > $out/bin/tapaal
    echo "${openjdk17}/bin/java -cp '$out/opt/lib/*' 'TAPAAL' 'tapaal'" >> $out/bin/tapaal
    chmod +x $out/bin/tapaal

    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    cp ${icon} $out/share/icons/hicolor/60x60/apps/tapaal.png
  '';

  meta = with lib; {
    description = "A tool for editing, simulation and verification of P/T and timed-arc Petri Nets";
    homepage = "https://www.tapaal.net/";
    license = licenses.osl3;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    platforms = platforms.all;
    maintainers = with maintainers; [ joeriexelmans ];
  };
}
