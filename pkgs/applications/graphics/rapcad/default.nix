{stdenv, fetchgit, qt4, cgal, boost, gmp, mpfr, flex, bison, dxflib}: 

stdenv.mkDerivation rec {
  version = "0.8.0";
  name = "rapcad-${version}";

  src = fetchgit {
    url = "https://github.com/GilesBathgate/RapCAD.git";
    rev = "refs/tags/v${version}";
    sha256 = "37c7107dc4fcf8942a4ad35377c4e42e6aedfa35296e5fcf8d84882ae35087c7";
  };
  
  buildInputs = [qt4 cgal boost boost.lib gmp mpfr flex bison dxflib];

  configurePhase = ''
    qmake;
    sed -e "s@/usr/@$out/@g" -i $(find . -name Makefile)
  '';

  meta = {
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = stdenv.lib.platforms.linux;
    description = ''Constructive solid geometry package'';
  };
}
