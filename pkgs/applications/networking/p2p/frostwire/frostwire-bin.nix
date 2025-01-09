{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  version = "6.13.3";
  pname = "frostwire";

  src = fetchurl {
    url = "https://github.com/frostwire/frostwire/releases/download/frostwire-desktop-${version}-build-322/frostwire-${version}.amd64.tar.gz";
    hash = "sha256-wRT8Oo+niOFBpEnq3pgjO9jpagZMgSE44V9RBYnGwig=";
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
    mainProgram = "frostwire";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ gavin ];
    platforms = [ "x86_64-linux" ];
  };
}
