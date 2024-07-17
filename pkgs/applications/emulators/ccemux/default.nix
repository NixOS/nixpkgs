{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
  jre,
  useCCTweaked ? true,
}:

let
  version = "unstable-2023-07-08";
  rev = "989cfe52a0458b991e0a7d87edec81d3fef472ac";

  baseUrl = "https://emux.cc/versions/${lib.substring 0 8 rev}/CCEmuX";
  jar =
    if useCCTweaked then
      fetchurl {
        url = "${baseUrl}-cct.jar";
        hash = "sha256-nna5KRp6jVLkbWKOHGtQqaPr3Zl05mVkCf/8X9C5lRY=";
      }
    else
      fetchurl {
        url = "${baseUrl}-cc.jar";
        hash = "sha256-2Z38O6z7OrHKe8GdLnexin749uJzQaCZglS+SwVD5YE=";
      };

  desktopIcon = fetchurl {
    url = "https://github.com/CCEmuX/CCEmuX/raw/${rev}/src/main/resources/img/icon.png";
    hash = "sha256-gqWURXaOFD/4aZnjmgtKb0T33NbrOdyRTMmLmV42q+4=";
  };
  desktopItem = makeDesktopItem {
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
    description = "Modular ComputerCraft emulator";
    homepage = "https://github.com/CCEmuX/CCEmuX";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mit;
    maintainers = with maintainers; [
      CrazedProgrammer
      viluon
    ];
    mainProgram = "ccemux";
  };
}
