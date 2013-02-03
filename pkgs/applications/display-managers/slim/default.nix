{ stdenv, fetchurl, cmake, pkgconfig, x11, libjpeg, libpng12, libXmu
, fontconfig, freetype, pam, dbus_libs }:

stdenv.mkDerivation rec {
  name = "slim-1.3.4";

  src = fetchurl {
    url = "http://download.berlios.de/slim/${name}.tar.gz";
    sha256 = "00fmrg2v41jnqhx0yc1kv97xxh5gai18n0i4as9g1fcq1i32cp0m";
  };

  patches = [
    # Allow the paths of the configuration file and theme directory to
    # be set at runtime.
    ./runtime-paths.patch
  ];

  buildInputs =
    [ cmake pkgconfig x11 libjpeg libpng12 libXmu fontconfig freetype
      pam dbus_libs
    ];

  preConfigure = "substituteInPlace CMakeLists.txt --replace /etc $out/etc";

  cmakeFlags = [ "-DUSE_PAM=1" ];

  NIX_CFLAGS_LINK = "-lXmu";

  meta = {
    homepage = http://slim.berlios.de;
    platforms = stdenv.lib.platforms.linux;
  };
}
