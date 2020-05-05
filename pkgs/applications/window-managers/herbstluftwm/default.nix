{ stdenv, fetchurl, cmake, pkgconfig, libX11, libXext, libXinerama, libXrandr
, withDoc ? stdenv.buildPlatform == stdenv.targetPlatform, asciidoc ? null
, nixosTests }:

# Doc generation is disabled by default when cross compiling because asciidoc
# does not cross compile for now

assert withDoc -> asciidoc != null;

stdenv.mkDerivation rec {
  pname = "herbstluftwm";
  version = "0.8.2";

  src = fetchurl {
    url = "https://herbstluftwm.org/tarballs/herbstluftwm-${version}.tar.gz";
    sha256 = "0wbl1s1gwdc61ll6qmkwb56swjxv99by1dhi080bdqn0w8p75804";
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

  passthru = {
    tests.herbstluftwm = nixosTests.herbstluftwm;
  };

  meta = {
    description = "A manual tiling window manager for X";
    homepage = "https://herbstluftwm.org/";
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thibautmarty ];
  };
}
