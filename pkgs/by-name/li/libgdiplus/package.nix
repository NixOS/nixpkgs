{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  glib,
  cairo,
  fontconfig,
  libtiff,
  giflib,
  libjpeg,
  libpng,
  libxrender,
  libexif,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgdiplus";
  version = "6.2";

  src = fetchFromGitLab {
    domain = "gitlab.winehq.org";
    owner = "mono";
    repo = "libgdiplus";
    tag = finalAttrs.version;
    hash = "sha256-otWdHiS/Ws+2tq5wQlcSfBUOc8Mfhpz5PLmMDgtld1Q=";
  };

  patches = [
    # Fix pkg-config lookup when cross-compiling.
    ./configure-pkg-config.patch
  ];

  postPatch = ''
    substituteInPlace Makefile.am \
      --replace-fail "all: update_submodules" "all:"
  '';

  env.NIX_LDFLAGS = "-lgif";

  outputs = [
    "out"
    "dev"
  ];

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = lib.optional stdenv.cc.isClang "--host=${stdenv.hostPlatform.system}";

  enableParallelBuilding = true;

  buildInputs = [
    glib
    cairo
    fontconfig
    libtiff
    giflib
    libjpeg
    libpng
    libxrender
    libexif
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s $out/lib/libgdiplus.0.dylib $out/lib/libgdiplus.so
  '';

  checkPhase = ''
    make check -w
  '';

  meta = {
    changelog = "https://gitlab.winehq.org/mono/libgdiplus/-/releases/${finalAttrs.src.tag}";
    description = "Mono library that provides a GDI+-compatible API on non-Windows operating systems";
    homepage = "https://www.mono-project.com/docs/gui/libgdiplus/";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    hasNoMaintainersButDependents = true;
  };
})
