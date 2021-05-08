{stdenv, lib, fetchFromGitHub, fetchgit, autoconf, automake, libtool,
gfortran, clang, cmake, curl, gnumake, hwloc, jre, openblas, hdf5, expat, ncurses,
readline, webkit, which, lp_solve, omniorb, sqlite, libatomic_ops,
pkgconfig, file, gettext, flex, bison, doxygen, boost, openscenegraph, gnome2,
ipopt, libuuid, zlib, libxml2,
xorg, git, bash, gtk2, makeWrapper, autoreconfHook,
openmodelica, mkOpenModelicaDerivation }:

mkOpenModelicaDerivation rec {
  pname = "omsimulator";
  omdir = "OMSimulator";
  omdeps = [openmodelica.omcompiler];

  nativeBuildInputs = [pkgconfig];

  buildInputs = [readline libxml2];
}
