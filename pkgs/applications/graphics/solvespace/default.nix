{ stdenv, fetchgit, autoreconfHook, fltk13
, libjpeg, libpng, mesa, pkgconfig }:

stdenv.mkDerivation {
  name = "solvespace-2.0";
  src = fetchgit {
    url = "https://github.com/jwesthues/solvespace.git";
    sha256 = "0sakxkmj2f0k27f67wy1xz2skpnwzg15yqrf7av97pgc5s8xb3da";
    rev = "e587d0e";
  };

  # e587d0e fails with undefined reference errors if make is called
  # twice. Ugly workaround: Build while installing.
  dontBuild = true;
  enableParallelBuilding = false;

  buildInputs = [
    autoreconfHook
    fltk13
    libjpeg
    libpng
    mesa
    pkgconfig
  ];

  meta = {
    description = "A parametric 3d CAD program";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://solvespace.com;
  };
}
