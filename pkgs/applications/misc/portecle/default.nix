{ stdenv, fetchurl, makeWrapper, unzip, bcprov, bcpkix, ant, jdk } :
stdenv.mkDerivation rec {
  name = "portecle-1.9";
  src = fetchurl {
    url = "mirror://sourceforge/portecle/${name}-src.zip";
    sha256 = "43efae9c9d20dd373f0a371c1506314afe5a10f88382e45671e06c2d0547b5e0";
  };
  nativeBuildInputs = [ ant jdk unzip makeWrapper ];
  patches = [ ./remove-pack200.patch ];
  buildPhase = ''
    rm lib/*.jar
    ln -s ${bcprov}/share/java/*.jar lib/bcprov-jdk15on-152.jar
    ln -s ${bcpkix}/share/java/*.jar lib/bcpkix-jdk15on-152.jar
    ant
  '';
  installPhase = ''
    mkdir -p $out/bin $out/lib/portecle
    cp build/portecle.jar $out/lib/portecle
    ln -s ${bcprov}/share/java/*.jar $out/lib/portecle/bcprov.jar
    ln -s ${bcpkix}/share/java/*.jar $out/lib/portecle/bcpkix.jar
    makeWrapper ${jdk.jre}/bin/java $out/bin/portecle --add-flags "-jar $out/lib/portecle/portecle.jar"
  '';
  meta = {
    description = "A user friendly GUI for creating, managing and examining keystores, keys etc.";
    homepage = "http://portecle.sourceforge.net/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
