{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apache-jena";
  version = "6.2.0";

  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-${finalAttrs.version}.tar.gz";
    hash = "sha256-FMEu9KovAHikc75LELAV4OC4XnZ9aGfoWBZ53o/sP24=";
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
})
