{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "apache-jena";
  version = "6.1.0";
  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-${version}.tar.gz";
    hash = "sha256-ZTEIqR/Zswmom8dWJYuuC8oBWHzvR1lC0RhS4766KuM=";
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    cp -r . "$out"
    for i in "$out"/bin/*; do
      wrapProgram "$i" --prefix "PATH" : "${jre}/bin/"
    done
  '';
  meta = {
    description = "RDF database";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    homepage = "https://jena.apache.org";
    downloadPage = "https://archive.apache.org/dist/jena/binaries/";
  };
}
