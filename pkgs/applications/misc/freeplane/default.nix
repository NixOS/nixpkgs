{ stdenv, lib, fetchzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "freeplane";
  version = "1.8.11";

  src = fetchzip {
    url = "https://sourceforge.net/projects/freeplane/files/freeplane%20stable/freeplane_bin-${version}.zip/download#freeplane_bin-${version}.zip";
    sha256 = "tJyJ7LQoeEFakjOgOU6yUA8dlCuXSCvbUB+gRq4ElMw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r * $out/share
    makeWrapper $out/share/freeplane.sh $out/bin/freeplane \
      --set JAVA_HOME "${jre}/lib/openjdk"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mind-mapping software";
    homepage = "https://www.freeplane.org/wiki/index.php/Home";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ maxhbr ];
    platforms = platforms.linux;
  };
}
