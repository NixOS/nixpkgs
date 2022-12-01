{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "jnetmap";
  version = "0.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/jnetmap/jNetMap%20${version}/jNetMap-${version}.jar";
    sha256 = "0nxsfa600jhazwbabxmr9j37mhwysp0fyrvczhv3f1smiy8rjanl";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"

    cp "${src}" "$out/lib/jnetmap.jar"
    makeWrapper "${jre}/bin/java" "$out/bin/jnetmap" \
        --add-flags "-jar \"$out/lib/jnetmap.jar\""
  '';

  meta = with lib; {
    description = "Graphical network monitoring and documentation tool";
    homepage = "http://www.rakudave.ch/jnetmap/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3Plus;
    # Upstream supports macOS and Windows too.
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
