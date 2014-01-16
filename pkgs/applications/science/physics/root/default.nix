{ stdenv, fetchurl, cmake, mesa, libX11, gfortran, libXpm, libXft, libXext, zlib }:

stdenv.mkDerivation rec {
  version = "5.34.14";
  name = "root-${version}";

  src = fetchurl {
    url = "ftp://root.cern.ch/root/root_v${version}.source.tar.gz";
    sha256 = "d5347ba1b614eb083cf08050b784d66a93c125ed89938708da1adb33323dee2b";
  };

  buildInputs = [ cmake gfortran mesa libX11 libXpm libXft libXext zlib ];

  # CMAKE_INSTALL_RPATH_USE_LINK_PATH is set to FALSE in
  # <rootsrc>/cmake/modules/RootBuildOptions.cmake.
  # This patch sets it to TRUE.
  patches = [ ./cmake.patch ];
  patchFlags = "-p0";

  meta = {
    description = "ROOT - A data analysis framework";
    homepage = http://root.cern.ch/drupal/;
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
