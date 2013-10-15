{ stdenv, fetchurl, cmake, pkgconfig, xorg, libjpeg, libpng
, fontconfig, freetype, pam, dbus_libs }:

stdenv.mkDerivation rec {
  name = "slim-1.3.6";

  src = fetchurl {
    url = "http://download.berlios.de/slim/${name}.tar.gz";
    sha256 = "1pqhk22jb4aja4hkrm7rjgbgzjyh7i4zswdgf5nw862l2znzxpi1";
  };

  patches =
    [ # Allow the paths of the configuration file and theme directory to
      # be set at runtime.
      ./runtime-paths.patch
    ];

  preConfigure = "substituteInPlace CMakeLists.txt --replace /etc $out/etc --replace /lib $out/lib";

  cmakeFlags = [ "-DUSE_PAM=1" ];

  enableParallelBuilding = true;

  buildInputs =
    [ cmake pkgconfig libjpeg libpng fontconfig freetype
      pam dbus_libs
      xorg.libX11 xorg.libXext xorg.libXrandr xorg.libXrender xorg.libXmu xorg.libXft
    ];

  NIX_CFLAGS_LINK = "-lXmu";

  meta = {
    homepage = http://slim.berlios.de;
    platforms = stdenv.lib.platforms.linux;
  };
}
