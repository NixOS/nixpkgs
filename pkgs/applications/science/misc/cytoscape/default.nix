{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  name = "cytoscape-${version}";
  version = "3.5.1";

  src = fetchurl {
    url = "http://chianti.ucsd.edu/${name}/${name}.tar.gz";
    sha256 = "1dvv0f7sc7q7lwmpd7xkcx86dd8lxh2il3wiwkij44gh7ni1qkfm";
  };

  buildInputs = [jre makeWrapper];

  installPhase = ''
    mkdir -pv $out/{share,bin}
    cp -Rv * $out/share/

    ln -s $out/share/cytoscape.sh $out/bin/cytoscape

    wrapProgram $out/share/cytoscape.sh \
      --set JAVA_HOME "${jre}" \
      --set JAVA  "${jre}/bin/java"

    chmod +x $out/bin/cytoscape
  '';

  meta = {
    homepage = "http://www.cytoscape.org";
    description = "A general platform for complex network analysis and visualization";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [stdenv.lib.maintainers.mimadrid];
    platforms = stdenv.lib.platforms.unix;
  };
}
