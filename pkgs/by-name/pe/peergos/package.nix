{ lib
, stdenv
, fetchurl
, jre
, makeWrapper
}:

let
  version = "0.14.1";
  peergos = fetchurl {
    url = "https://github.com/Peergos/web-ui/releases/download/v${version}/Peergos.jar";
    hash = "sha256-oCsUuFxTAL0vAabGggGhZHaF40A5TLfkT15HYPiKHlU=";
  };
in
stdenv.mkDerivation rec {
  pname = "peergos";
  inherit version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D ${peergos} $out/share/java/peergos.jar
    makeWrapper ${lib.getExe jre} $out/bin/${pname} \
      --add-flags "-jar -Djava.library.path=native-lib $out/share/java/${pname}.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A p2p, secure file storage, social network and application protocol";
    mainProgram = "peergos";
    homepage = "https://peergos.org/";
    # peergos have agpt3 license, peergos-web-ui have gpl3, both are used
    license = [ licenses.agpl3Only licenses.gpl3Only ];
    platforms = platforms.all;
    maintainers = with maintainers; [ raspher ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
