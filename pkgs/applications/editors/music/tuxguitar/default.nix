{ stdenv, fetchurl, swt, jdk, makeWrapper, alsaLib }:

let metadata = assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";
  if stdenv.system == "i686-linux" then
    { arch = "x86"; sha256 = "1qmb51k0538pn7gv4nsvhfv33xik4l4af0qmpllkzrikmj8wvzlb"; }
  else
    { arch = "x86_64"; sha256 = "12af47jhlrh9aq5b3d13l7cdhlndgnfpy61gz002hajbq7i00ixh"; };
in stdenv.mkDerivation rec {
  version = "1.2";
  name = "tuxguitar-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/tuxguitar/${name}-linux-${metadata.arch}.tar.gz";
    sha256 = metadata.sha256;
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r lib share $out/
    cp tuxguitar $out/bin/tuxguitar
    cp tuxguitar.jar $out/lib

    ln -s $out/share $out/bin/share

    wrapProgram $out/bin/tuxguitar \
      --set JAVA "${jdk}/bin/java" \
      --prefix LD_LIBRARY_PATH : "$out/lib/:${swt}/lib:${alsaLib.out}/lib" \
      --prefix CLASSPATH : "${swt}/jars/swt.jar:$out/lib/tuxguitar.jar:$out/lib/itext.jar"
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
