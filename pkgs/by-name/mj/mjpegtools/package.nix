{
  stdenv,
  lib,
  fetchurl,
  gtk2,
  libdv,
  libjpeg,
  libpng,
  libX11,
  pkg-config,
  SDL,
  SDL_gfx,
  withMinimal ? true,
}:

# TODO:
# - make dependencies optional
# - libpng-apng as alternative to libpng?
# - libXxf86dga support? checking for XF86DGAQueryExtension in -lXxf86dga... no

stdenv.mkDerivation rec {
  pname = "mjpegtools";
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/mjpeg/mjpegtools-${version}.tar.gz";
    sha256 = "sha256-sYBTbX2ZYLBeACOhl7ANyxAJKaSaq3HRnVX0obIQ9Jo=";
  };

  patches = [
    # Clang 16 defaults to C++17. `std::auto_ptr` has been removed from C++17,
    # and the `register` type class specifier is no longer allowed.
    ./c++-17-fixes.patch

    # Clang-19 errors out for dead code (in header) which accesses undefined
    # class members
    ./remove-subtract-and-union-debug.diff
  ];

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libdv
    libjpeg
    libpng
  ]
  ++ lib.optionals (!withMinimal) [
    gtk2
    libX11
    SDL
    SDL_gfx
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (!withMinimal) "-I${lib.getDev SDL}/include/SDL";

  postPatch = ''
    sed -i -e '/ARCHFLAGS=/s:=.*:=:' configure
  '';

  enableParallelBuilding = true;

  outputs = [
    "out"
    "lib"
  ];

  meta = with lib; {
    description = "Suite of programs for processing MPEG or MJPEG video";
    homepage = "http://mjpeg.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
