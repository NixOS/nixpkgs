{ stdenv, fetchgit, cgal, boost, gmp, mpfr, flex, bison, dxflib, readline
, qtbase, qmakeHook, mesa_glu
}:

stdenv.mkDerivation rec {
  version = "0.9.5";
  name = "rapcad-${version}";

  src = fetchgit {
    url = "https://github.com/GilesBathgate/RapCAD.git";
    rev = "refs/tags/v${version}";
    sha256 = "1i5h4sw7mdbpdbssmbjccwgidndrsc606zz4wy9pjsg2wzrabw7x";
  };

  buildInputs = [ qtbase qmakeHook cgal boost gmp mpfr flex bison dxflib readline mesa_glu ];

  meta = {
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = stdenv.lib.platforms.linux;
    description = ''Constructive solid geometry package'';
  };
}
