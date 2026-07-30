{
  stdenv,
  lib,
  fetchurl,
  fixDarwinDylibNames,

  # for passthru.tests
  SDL2_image,
  SDL_image,
  gdal,
  imlib2,
  leptonica,
  libjxl,
  libwebp,
  openimageio,
  openjdk,
  pkgsStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "giflib";
  version = "6.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/giflib/giflib-${finalAttrs.version}.tar.gz";
    hash = "sha256-tltmuZ8EJLk1JfmHOG8i/F77naK/ySrUpTIkmq/7qw4=";
  };

  patches = [
    # Fix missing symbol error on Darwin when linking libutil.dylib.
    # Based on discussion in https://sourceforge.net/p/giflib/bugs/189/.
    ./0001-Suppress-undefined-symbol-error-on-Darwin.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    # Build dll libraries.
    (fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/001-mingw-build.patch?h=mingw-w64-giflib&id=b7311edf54824ac797c7916cd3ddc3a4b2368a19";
      hash = "sha256-bBx7lw7FWtxZJ+E9AAbKIpCGcJnS5lrGpjYcv/zBtKk=";
    })

    # Install executables.
    ./mingw-install-exes.patch
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postPatch = ''
    # we don't want to build HTML documentation
    substituteInPlace doc/Makefile \
      --replace-fail "all: allhtml manpages" "all: manpages"
  ''
  + lib.optionalString stdenv.hostPlatform.isStatic ''
    # Upstream build system does not support NOT building shared libraries.
    sed -i '/all:/ s/$(LIBGIFSO)//' Makefile
    sed -i '/all:/ s/$(LIBUTILSO)//' Makefile
    sed -i '/-m 755 $(LIBGIFSO)/ d' Makefile
    sed -i '/ln -sf $(LIBGIFSOVER)/ d' Makefile
    sed -i '/ln -sf $(LIBGIFSOMAJOR)/ d' Makefile
  '';

  passthru.tests = {
    static = pkgsStatic.giflib;
    inherit
      SDL2_image
      SDL_image
      gdal
      imlib2
      leptonica
      libjxl
      openimageio
      openjdk
      ;
  };

  meta = {
    description = "Library for reading and writing gif images";
    homepage = "https://giflib.sourceforge.net/";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    license = lib.licenses.mit;
    maintainers = [ ];
    branch = "5.2";
  };
})
