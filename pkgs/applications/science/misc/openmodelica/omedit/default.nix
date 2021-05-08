{stdenv, lib, mkDerivation, fetchFromGitHub, fetchgit, autoconf, automake, libtool,
gfortran, clang, cmake, curl, gnumake, hwloc, jre, openblas, hdf5, expat, ncurses,
readline, qtbase, qtwebkit, webkit, which, lp_solve, omniorb, sqlite, libatomic_ops,
pkgconfig, file, gettext, flex, bison, doxygen, boost, openscenegraph, gnome2,
ipopt, libuuid, qtxmlpatterns, zlib, binutils,
xorg, git, bash, gtk2, makeWrapper, autoreconfHook, qttools, qmake,
openmodelica, mkOpenModelicaDerivation, wrapQtAppsHook }:
with openmodelica;
mkOpenModelicaDerivation rec {
  pname = "omedit";
  omdir = "OMEdit";
  omdeps = [omcompiler omplot omparser omsimulator];
  omautoconf = true;

  nativeBuildInputs = [jre qmake qtbase qttools wrapQtAppsHook];

  buildInputs = [qtwebkit qtxmlpatterns binutils];

  patchPhase = ''
    sed -i ''$(find -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qttools}/bin/lrelease|'
    '';

  dontUseQmakeConfigure = true;
}
