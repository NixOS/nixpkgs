{ lib, stdenv, fetchurl, makeDesktopItem, makeWrapper, jre
, useCCTweaked ? true
}:

let
  version = "1.1.1";
  rev = "af12e2e4da586275ba931eae8f40a2201251bf59";

  baseUrl = "https://emux.cc/versions/${lib.substring 0 8 rev}/CCEmuX";
  jar =
    if useCCTweaked
    then fetchurl {
      url = "${baseUrl}-cct.jar";
      sha256 = "0d9gzi1h5vz32fp4lfn7dam189jcm7bwbqwmlpj0c47p8l0d4lsv";
    }
    else fetchurl {
      url = "${baseUrl}-cc.jar";
      sha256 = "0ky5vxh8m1v98zllifxif8xxd25j2xdp19hjnj4xlkck71lbnb34";
    };

  desktopIcon = fetchurl {
    url = "https://github.com/CCEmuX/CCEmuX/raw/${rev}/src/main/resources/img/icon.png";
    sha256 = "1vmb6rg9k2y99j8xqfgbsvfgfi3g985rmqwrd7w3y54ffr2r99c2";
  };
  desktopItem =  makeDesktopItem {
    name = "CCEmuX";
    exec = "ccemux";
    icon = desktopIcon;
    comment = "A modular ComputerCraft emulator";
    desktopName = "CCEmuX";
    genericName = "ComputerCraft Emulator";
    categories = [ "Emulator" ];
  };
in

stdenv.mkDerivation rec {
  pname = "ccemux";
  inherit version;

  src = jar;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/ccemux}
    cp -r ${desktopItem}/share/applications $out/share/applications

    install -D ${src} $out/share/ccemux/ccemux.jar
    install -D ${desktopIcon} $out/share/pixmaps/ccemux.png

    makeWrapper ${jre}/bin/java $out/bin/ccemux \
      --add-flags "-jar $out/share/ccemux/ccemux.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A modular ComputerCraft emulator";
    homepage = "https://github.com/CCEmuX/CCEmuX";
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
  };
}
