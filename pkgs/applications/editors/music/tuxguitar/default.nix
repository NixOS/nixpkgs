{ stdenv, fetchurl, swt, jdk, makeWrapper, alsaLib }:

let metadata = if stdenv.system == "i686-linux"
               then { arch = "x86"; sha256 = "1qmb51k0538pn7gv4nsvhfv33xik4l4af0qmpllkzrikmj8wvzlb"; }
               else if stdenv.system == "x86_64-linux"
                    then { arch = "x86_64"; sha256 = "12af47jhlrh9aq5b3d13l7cdhlndgnfpy61gz002hajbq7i00ixh"; }
                    else { };
in stdenv.mkDerivation rec {
  version = "1.2";
  name = "tuxguitar-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/tuxguitar/${name}-linux-${metadata.arch}.tar.gz";
    sha256 = metadata.sha256;
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out/

    wrapProgram $out/tuxguitar \
      --set JAVA "${jdk}/bin/java" \
      --prefix LD_LIBRARY_PATH : "${swt}/lib:${alsaLib}/lib" \
      --prefix CLASSPATH : "${swt}/jars/swt.jar"
  '';

  meta = with stdenv.lib; {
    description = "A multitrack guitar tablature editor";
    longDescription = ''
      TuxGuitar is a multitrack guitar tablature editor and player written
      in Java-SWT. It can open GuitarPro, PowerTab and TablEdit files.
    '';
    homepage = http://www.tuxguitar.com.ar/;
    license = licenses.lgpl2;
    maintainers = [ maintainers.ardumont ];
    platforms = platforms.linux;
  };
}
