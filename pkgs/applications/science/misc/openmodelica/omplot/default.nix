{stdenv, lib, mkDerivation, fetchFromGitHub, fetchgit, autoconf, automake, libtool,
gfortran, clang, cmake, curl, gnumake, hwloc, jre, openblas, hdf5, expat, ncurses,
readline, qtbase, qtwebkit, webkit, which, lp_solve, omniorb, sqlite, libatomic_ops,
pkgconfig, file, gettext, flex, bison, doxygen, boost, openscenegraph, gnome2,
ipopt, libuuid, qtxmlpatterns,
xorg, git, bash, gtk2, makeWrapper, autoreconfHook, qttools, qmake,
openmodelica, mkOpenModelicaDerivation, wrapQtAppsHook }:

mkOpenModelicaDerivation rec {
  pname = "omplot";
  omdir = "OMPlot";
  omdeps = [openmodelica.omcompiler];
  omautoconf = true;

  nativeBuildInputs = [qtbase qttools qmake wrapQtAppsHook];

  buildInputs = [];

  patchPhase = ''
    sed -i OMPlot/Makefile.in -e 's|bindir = @includedir@|includedir = @includedir@|'
    sed -i OMPlot/OMPlot/OMPlotGUI/*.pro -e '/INCLUDEPATH +=/s|$| ../../qwt/src|'
    sed -i ''$(find -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qttools}/bin/lrelease|'
    '';

  dontUseQmakeConfigure = true;
}
