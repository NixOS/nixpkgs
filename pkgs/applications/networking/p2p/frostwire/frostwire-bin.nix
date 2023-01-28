{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "6.9.8";
  pname = "frostwire";

  src = fetchurl {
    url = "https://dl.frostwire.com/frostwire/${version}/frostwire-${version}.amd64.tar.gz";
    sha256 = "sha256-gslNdvxA4rGKg0bjf2KWw7w9NMp3zqrii144AfKsV4s=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    mv $(ls */*.jar) $out/share/java

    makeWrapper $out/share/java/frostwire $out/bin/frostwire \
      --prefix PATH : ${jre}/bin \
      --prefix LD_LIBRARY_PATH : $out/share/java \
      --set JAVA_HOME "${jre}"

    substituteInPlace $out/share/java/frostwire \
      --replace "export JAVA_PROGRAM_DIR=/usr/lib/frostwire/jre/bin" \
        "export JAVA_PROGRAM_DIR=${jre}/bin/"

    substituteInPlace $out/share/java/frostwire.desktop \
      --replace "Exec=/usr/bin/frostwire %U" "Exec=${placeholder "out"}/bin/frostwire %U"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.frostwire.com/";
    description = "BitTorrent Client and Cloud File Downloader";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ gavin ];
    platforms = [ "x86_64-linux"];
  };
}
