{ stdenv, fetchurl, fetchpatch, cmake, pkgconfig, xorg, libjpeg, libpng
, fontconfig, freetype, pam, dbus_libs, makeWrapper }:

stdenv.mkDerivation rec {
  name = "slim-1.3.6";

  src = fetchurl {
    url = "mirror://sourceforge/slim.berlios/${name}.tar.gz";
    sha256 = "1pqhk22jb4aja4hkrm7rjgbgzjyh7i4zswdgf5nw862l2znzxpi1";
  };

  patches =
    [ # Allow the paths of the configuration file and theme directory to
      # be set at runtime.
      ./runtime-paths.patch

      # Exit after the user's session has finished.  This works around
      # slim's broken PAM session handling (see
      # http://developer.berlios.de/bugs/?func=detailbug&bug_id=19102&group_id=2663).
      ./run-once.patch

      # Ensure that sessions appear in sort order, rather than in
      # directory order.
      ./sort-sessions.patch

      # Allow to set logfile to a special "/dev/stderr" in order to continue
      # logging to stderr and thus to the journal.
      ./no-logfile.patch
    ] ++ stdenv.lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/musl/8eddda8072add075ebf56cf6d288bc1450d6b5f8/x11-misc/slim/files/slim-1.3.6-add-missing-libgen_h.patch";
      sha256 = "0f82672s2r2cmdqfn2mbg3di76mbla9n0ik20p2gv4igi6p866xm";
    });

  preConfigure = "substituteInPlace CMakeLists.txt --replace /lib $out/lib";

  cmakeFlags = [ "-DUSE_PAM=1" ];

  NIX_CFLAGS_COMPILE = "-I${freetype.dev}/include/freetype -std=c++11";

  enableParallelBuilding = true;

  buildInputs =
    [ cmake pkgconfig libjpeg libpng fontconfig freetype
      pam dbus_libs
      xorg.libX11 xorg.libXext xorg.libXrandr xorg.libXrender xorg.libXmu xorg.libXft makeWrapper
    ];

  NIX_CFLAGS_LINK = "-lXmu";

  meta = {
    homepage = https://sourceforge.net/projects/slim.berlios/; # berlios shut down; I found no replacement yet
    platforms = stdenv.lib.platforms.linux;
  };
}
