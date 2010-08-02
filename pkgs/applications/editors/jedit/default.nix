{ stdenv, fetchurl, ant }:

stdenv.mkDerivation {
  name = "jedit-4.2";

  src = fetchurl {
    url = mirror://sf/jedit/jedit42source.tar.gz;
    sha256 = "1ckqghsw2r30kfkqfgjl4k47gdwpz8c1h85haw0y0ymq4rqh798j";
  };

  phases = "unpackPhase buildPhase";

  buildPhase = "
     sed -i 's/\\<SplashScreen\\>/org.gjt.sp.jedit.gui.SplashScreen/g' org/gjt/sp/jedit/GUIUtilities.java
    ant dist
    ensureDir $out/lib
    cp jedit.jar $out/lib
    ensureDir \$out/lib/modes
    cp modes/catalog \$out/lib/modes
  ";

  buildInputs = [ ant ];

  meta = { 
    description = "really nice programmers editor written in Java. Give it a try";
    homepage = http://www.jedit.org;
    license = "GPL";
  };
}
