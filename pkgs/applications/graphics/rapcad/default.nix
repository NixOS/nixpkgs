{ stdenv, fetchgit, cgal, boost, gmp, mpfr, flex, bison, dxflib, readline
, qtbase
}:

stdenv.mkDerivation rec {
  version = "0.9.5";
  name = "rapcad-${version}";

  src = fetchgit {
    url = "https://github.com/GilesBathgate/RapCAD.git";
    rev = "refs/tags/v${version}";
    sha256 = "15c18jvgbwyrfhv7r35ih0gzx35vjlsbi984h1sckgh2z17hjq8l";
  };

  buildInputs = [ qtbase cgal boost gmp mpfr flex bison dxflib readline ];

  configurePhase = ''
    runHook preConfigure
    qmake
    sed -e "s@/usr/@$out/@g" -i $(find . -name Makefile)
    runHook postConfigure
  '';

  meta = {
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = stdenv.lib.platforms.linux;
    description = ''Constructive solid geometry package'';
  };
}
