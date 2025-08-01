{
  fetchurl,
  fetchpatch,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "gsl";
  version = "2.8";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnu/gsl/${pname}-${version}.tar.gz";
    hash = "sha256-apnu7RVjLGNUiVsd1ULtWoVcDxXZrRMmxv4rLJ5CMZA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/90be777d2ce451d3c23783cb2be0efab9732e4d0/math/gsl/files/patch-fix-linking.diff";
      extraPrefix = "";
      hash = "sha256-lweYndIxcM5+4ckIUubkD9XbJbqkfdK+y9c3aRzmq0M=";
    })
  ];

  preConfigure =
    if
      (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11" && stdenv.hostPlatform.isDarwin)
    then
      ''
        MACOSX_DEPLOYMENT_TARGET=10.16
      ''
    else
      null;

  postInstall = ''
    moveToOutput bin/gsl-config "$dev"
  '';

  # do not let -march=skylake to enable FMA (https://lists.gnu.org/archive/html/bug-gsl/2011-11/msg00019.html)
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-mno-fma";

  # https://lists.gnu.org/archive/html/bug-gsl/2015-11/msg00012.html
  doCheck = stdenv.hostPlatform.system != "i686-linux";

  meta = {
    description = "GNU Scientific Library, a large numerical library";
    homepage = "https://www.gnu.org/software/gsl/";
    license = lib.licenses.gpl3Plus;

    longDescription = ''
      The GNU Scientific Library (GSL) is a numerical library for C
      and C++ programmers.  It is free software under the GNU General
      Public License.

      The library provides a wide range of mathematical routines such
      as random number generators, special functions and least-squares
      fitting.  There are over 1000 functions in total with an
      extensive test suite.
    '';
    platforms = lib.platforms.all;
  };
}
