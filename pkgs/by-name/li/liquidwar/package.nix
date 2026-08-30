{
  lib,
  stdenv,
  fetchurl,
  xorgproto,
  libx11,
  libxrender,
  gmp,
  libjpeg,
  libpng,
  expat,
  gettext,
  perl,
  guile,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_ttf,
  curl,
  sqlite,
  libtool,
  readline,
  libogg,
  libvorbis,
  libcaca,
  csound,
  cunit,
  pkg-config,
  libGL,
  libGLU,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liquidwar6";
  version = "0.6.3902";

  src = fetchurl {
    url = "mirror://gnu/liquidwar6/liquidwar6-${finalAttrs.version}.tar.gz";
    sha256 = "1976nnl83d8wspjhb5d5ivdvdxgb8lp34wp54jal60z4zad581fn";
  };

  postPatch =
    # configure: Liquid War 6 needs Guile 1.8 or 2.0
    ''
      substituteInPlace configure \
        --replace-fail "guile/2.0" "guile/3.0" \
        --replace-fail "guile-2.0" "guile-3.0" \
        --replace-fail "LIBGUILE2" "LIBGUILE3"
    ''
    # error: 'SCM_LIST0' undeclared (first use in this function)
    + ''
      substituteInPlace src/lib/lw6-funcs{ldr,gui,pil,sys}.c \
        --replace-fail "SCM_LIST0" "SCM_EOL"
    ''
    # ATTENTION! script returned false, something is wrong
    + ''
      substituteInPlace script/liquidwar6.scm \
        --replace-fail "(lazy-catch #t" "(catch #t"
    '';

  buildInputs = [
    xorgproto
    libx11
    gmp
    guile
    libjpeg
    libpng
    expat
    gettext
    perl
    SDL
    SDL_image
    SDL_mixer
    SDL_ttf
    curl
    sqlite
    libogg
    libvorbis
    csound
    libxrender
    libcaca
    cunit
    libtool
    readline
    libGL
    libGLU
  ];

  nativeBuildInputs = [ pkg-config ];

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
      # Needed with GCC 12 but problematic with some old GCCs
      "-Wno-error=address"
      "-Wno-error=use-after-free"
      "-std=gnu17"
    ]
    ++ [
      "-Wno-error=deprecated-declarations"
      # Avoid GL_GLEXT_VERSION double definition
      " -DNO_SDL_GLEXT"
    ]
  );

  # To avoid problems finding SDL_types.h.
  configureFlags = [ "CFLAGS=-I${lib.getDev SDL}/include/SDL" ];

  meta = {
    description = "Quick tactics game";
    homepage = "https://www.gnu.org/software/liquidwar6/";
    maintainers = [ lib.maintainers.raskin ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
