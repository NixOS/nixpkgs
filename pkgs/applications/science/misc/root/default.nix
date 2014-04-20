{ stdenv, fetchurl, cmake, mesa, libX11, gfortran, libXpm, libXft, libXext, zlib }:

stdenv.mkDerivation rec {
  name = "root-${version}";
  version = "5.34.15";

  src = fetchurl {
    url = "ftp://root.cern.ch/root/root_v${version}.source.tar.gz";
    sha256 = "1bkiggcyya39a794d3d2rzzmmkbdymf86hbqhh0l1pl4f38xvp6i";
  };

  buildInputs = [ cmake gfortran mesa libX11 libXpm libXft libXext zlib ];

  # CMAKE_INSTALL_RPATH_USE_LINK_PATH is set to FALSE in
  # <rootsrc>/cmake/modules/RootBuildOptions.cmake.
  # This patch sets it to TRUE.
  patches = [ ./cmake.patch ];
  patchFlags = "-p0";

  enableParallelBuilding = true;

  meta = {
    homepage = "http://root.cern.ch/drupal/";
    description = "A data analysis framework";
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
