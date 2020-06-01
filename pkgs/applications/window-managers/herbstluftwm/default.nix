{ stdenv, fetchurl, cmake, pkgconfig, glib, libX11, libXext, libXinerama, libXrandr
, withDoc ? stdenv.buildPlatform == stdenv.targetPlatform, asciidoc ? null }:

# Doc generation is disabled by default when cross compiling because asciidoc
# does not cross compile for now

assert withDoc -> asciidoc != null;

stdenv.mkDerivation rec {
  pname = "herbstluftwm";
  version = "0.8.1";

  src = fetchurl {
    url = "https://herbstluftwm.org/tarballs/herbstluftwm-${version}.tar.gz";
    sha256 = "0c1lf82z6a56g8asin91cmqhzk3anw0xwc44b31bpjixadmns57y";
  };

  outputs = [
    "out"
  ] ++ stdenv.lib.optionals withDoc [
    "doc"
    "man"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_SYSCONF_PREFIX=${placeholder "out"}/etc"
  ] ++ stdenv.lib.optional (!withDoc) "-DWITH_DOCUMENTATION=OFF";

  nativeBuildInputs = [
    cmake
    pkgconfig
  ] ++ stdenv.lib.optional withDoc asciidoc;

  buildInputs = [
    libX11
    libXext
    libXinerama
    libXrandr
  ];

  meta = {
    description = "A manual tiling window manager for X";
    homepage = "https://herbstluftwm.org/";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
  };
}
