{ jre, lib, stdenv, fetchurl, makeWrapper, makeDesktopItem }:

let

  desktopItem = makeDesktopItem rec {
    name = "netlogo";
    exec = name;
    icon = name;
    comment = "A multi-agent programmable modeling environment";
    desktopName = "NetLogo";
    categories = [ "Science" ];
  };

in

stdenv.mkDerivation rec {
  pname = "netlogo";
  version = "6.1.1";

  src = fetchurl {
    url = "https://ccl.northwestern.edu/netlogo/${version}/NetLogo-${version}-64.tgz";
    sha256 = "1j08df68pgggxqkmpzd369w4h97q0pivmmljdb48hjghx7hacblp";
  };

  src1 = fetchurl {
    name = "netlogo.png";
    url = "https://netlogoweb.org/assets/images/desktopicon.png";
    sha256 = "1i43lhr31lzva8d2r0dxpcgr58x496gb5vmb0h2da137ayvifar8";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -pv $out/share/netlogo $out/share/icons/hicolor/256x256/apps $out/share/applications $out/share/doc
    cp -rv app $out/share/netlogo
    cp -v readme.md $out/share/doc/

    # launcher with `cd` is required b/c otherwise the model library isn't usable
    makeWrapper "${jre}/bin/java" "$out/bin/netlogo" \
      --chdir "$out/share/netlogo/app" \
      --add-flags "-jar netlogo-${version}.jar"

    cp $src1 $out/share/icons/hicolor/256x256/apps/netlogo.png
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = with lib; {
    description = "Multi-agent programmable modeling environment";
    mainProgram = "netlogo";
    longDescription = ''
      NetLogo is a multi-agent programmable modeling environment. It is used by
      many tens of thousands of students, teachers and researchers worldwide.
    '';
    homepage = "https://ccl.northwestern.edu/netlogo/index.shtml";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2;
    maintainers = [ maintainers.dpaetzel ];
    platforms = platforms.linux;
  };
}
