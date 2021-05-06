{stdenv, lib, mkDerivation, fetchFromGitHub, fetchgit, autoconf, automake, libtool,
gfortran, clang, cmake, curl, gnumake, hwloc, jre, openblas, hdf5, expat, ncurses,
readline, qtbase, qtwebkit, webkit, which, lp_solve, omniorb, sqlite, libatomic_ops,
pkgconfig, file, gettext, flex, bison, doxygen, boost, openscenegraph, gnome2,
ipopt, libuuid, qtxmlpatterns,
xorg, git, bash, gtk2, makeWrapper, autoreconfHook,
openmodelica, mkOpenModelicaDerivation }:

mkOpenModelicaDerivation rec {
  pname = "omplot";
  omdeps = [openmodelica.omcompiler];

  nativeBuildInputs = [autoconf automake libtool cmake gfortran clang makeWrapper
    flex bison doxygen
    pkgconfig file
    autoreconfHook];

  buildInputs = [hwloc curl
    jre openblas hdf5 expat ncurses readline qtbase qtwebkit webkit which lp_solve
    omniorb sqlite libatomic_ops gettext boost
    ipopt libuuid qtxmlpatterns openmodelica.omcompiler
    openscenegraph gnome2.gtkglext xorg.libXmu git gtk2 makeWrapper];
}
