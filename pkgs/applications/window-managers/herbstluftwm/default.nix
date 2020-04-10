{ stdenv, fetchurl, cmake, pkgconfig, glib, libX11, libXext, libXinerama, libXrandr
, withDoc ? stdenv.buildPlatform == stdenv.targetPlatform, asciidoc ? null }:

# Doc generation is disabled by default when cross compiling because asciidoc
# does not cross compile for now

assert withDoc -> asciidoc != null;

stdenv.mkDerivation rec {
  pname = "herbstluftwm";
  version = "0.8.0";

  src = fetchurl {
    url = "https://herbstluftwm.org/tarballs/herbstluftwm-${version}.tar.gz";
    sha256 = "04n8cmrgb490kfn70x9kgxp286mrrn7nb4irhi7nvbm6lv0z28sq";
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
    glib
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
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
