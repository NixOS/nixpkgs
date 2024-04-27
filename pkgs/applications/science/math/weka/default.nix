{ lib, stdenv, fetchurl, jre, unzip, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "weka";
  version = "3.9.6";

  src = fetchurl {
    url = "mirror://sourceforge/weka/${lib.replaceStrings ["."]["-"] "${pname}-${version}"}.zip";
    sha256 = "sha256-8fVN4MXYqXNEmyVtXh1IrauHTBZWgWG8AvsGI5Y9Aj0=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];

  # The -Xmx1000M comes suggested from their download page:
  # https://www.cs.waikato.ac.nz/ml/weka/downloading.html
  installPhase = ''
    mkdir -pv $out/share/weka
    cp -Rv * $out/share/weka

    makeWrapper ${jre}/bin/java $out/bin/weka \
      --add-flags "-Xmx1000M -jar $out/share/weka/weka.jar"
  '';

  meta = with lib; {
    homepage = "https://www.cs.waikato.ac.nz/ml/weka/";
    description = "Collection of machine learning algorithms for data mining tasks";
    mainProgram = "weka";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.mimame ];
    platforms = platforms.unix;
  };
}
