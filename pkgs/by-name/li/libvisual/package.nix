{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  SDL,
  autoreconfHook,
  glib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libvisual";
  version = "0.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/libvisual/${pname}-${version}.tar.gz";
    hash = "sha256-qhKHdBf3bTZC2fTHIzAjgNgzF1Y51jpVZB0Bkopd230=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # pull upstream fix for SDL1 cross-compilation.
    #   https://github.com/Libvisual/libvisual/pull/238
    (fetchpatch {
      name = "sdl-cross-prereq.patch";
      url = "https://github.com/Libvisual/libvisual/commit/7902d24aa1a552619a5738339b3823e90dd3b865.patch";
      hash = "sha256-84u8klHDAw/q4d+9L4ROAr7XsbXItHrhaEKkTEMSPcc=";
      # remove extra libvisual prefix
      stripLen = 1;
      # pull in only useful configure.ac changes.
      excludes = [ "Makefile.am" ];
    })
    (fetchpatch {
      name = "sdl-cross-pc.patch";
      url = "https://github.com/Libvisual/libvisual/commit/f79a2e8d21ad1d7fe26e2aa83cea4c9f48f9e392.patch";
      hash = "sha256-8c7SdLxXC8K9BAwj7DzozsZAcbs5l1xuBqky9LJ1MfM=";
      # remove extra libvisual prefix
      stripLen = 1;
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    SDL
    glib
  ];

  configureFlags =
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      # Remove once "sdl-cross-prereq.patch" patch above is removed.
      "--disable-lv-tool"
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes"
    ];

  meta = {
    description = "Abstraction library for audio visualisations";
    homepage = "https://sourceforge.net/projects/libvisual/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
