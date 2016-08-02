{ stdenv, fetchurl, pkgconfig, libX11, libXpm, libXext }:

stdenv.mkDerivation {
  name = "wmCalClock-1.25";
  src = fetchurl {
     url = http://www.cs.mun.ca/~gstarkes/wmaker/dockapps/files/wmCalClock-1.25.tar.gz;
     sha256 = "4b42b55bb7c1d7c58b5ee1f0058c683d3e4f3e3380d3a69c54a50b983c7c1b3f";
  };

  buildInputs = [ pkgconfig libX11 libXpm libXext ];

  postUnpack = "sourceRoot=\${sourceRoot}/Src";

  buildPhase=''
    make prefix=$out
  '';

  installPhase = ''
    mkdir -pv $out/bin
    mkdir -pv $out/man/man1
    make DESTDIR=$out install
  '';

  meta = {
    description = "Clock for Windowmaker";
    homepage = "http://www.cs.mun.ca/~gstarkes/wmaker/dockapps/time.html#wmcalclock";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.bstrik ];
    platforms = stdenv.lib.platforms.linux;
  };
}
