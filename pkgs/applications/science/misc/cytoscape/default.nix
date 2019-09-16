{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "cytoscape";
  version = "3.7.2";

  src = fetchurl {
    url = "https://github.com/cytoscape/cytoscape/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "125vgr8vqbmy2nsm1yl0h0q8p49lxxqfw5cmxzbx1caklcn4rryc";
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
    homepage = http://www.cytoscape.org;
    description = "A general platform for complex network analysis and visualization";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [stdenv.lib.maintainers.mimame];
    platforms = stdenv.lib.platforms.unix;
  };
}
