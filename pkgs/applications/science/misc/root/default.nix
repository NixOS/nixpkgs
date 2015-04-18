{ stdenv, fetchurl, fetchpatch, cmake, mesa, gfortran
, libX11,libXpm, libXft, libXext, zlib }:

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
  patches = [
    ./cmake.patch
    (fetchpatch {
      name = "fix-tm_t-member.diff";
      url = "https://github.com/root-mirror/root/commit/"
        + "08b08412bafc24fa635b0fdb832097a3aa2fa1d2.diff";
      sha256 = "0apbp51pk8471gl06agx3i88dn76p6gpkgf1ssfhcyam0bjl8907";
    })
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://root.cern.ch/drupal/";
    description = "A data analysis framework";
    platforms = stdenv.lib.platforms.linux;
  };
}
