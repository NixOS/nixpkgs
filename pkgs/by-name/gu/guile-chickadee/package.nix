{
  lib,
  autoreconfHook,
  fetchurl,
  freetype,
  guile,
  guile-opengl,
  guile-sdl2,
  libjpeg_turbo,
  libpng,
  libvorbis,
  makeWrapper,
  mpg123,
  openal,
  pkg-config,
  readline,
  stdenv,
  testers,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-chickadee";
  version = "0.10.0";

  src = fetchurl {
    url = "https://files.dthompson.us/chickadee/chickadee-${finalAttrs.version}.tar.gz";
    hash = "sha256-Ey9TtuWaGlHG2cYYwqJIt2RX7XNUW28OGl/kuPUCD3U=";
  };

  nativeBuildInputs = [
    autoreconfHook
    guile
    makeWrapper
    pkg-config
    texinfo
  ];

  buildInputs = [
    freetype
    guile
    libjpeg_turbo
    libpng
    libvorbis
    mpg123
    openal
    readline
  ];

  propagatedBuildInputs = [
    guile-opengl
    guile-sdl2
  ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  strictDeps = true;

  postInstall = ''
    wrapProgram $out/bin/chickadee \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "chickadee -v";
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://dthompson.us/projects/chickadee.html";
    description = "Game development toolkit for Guile Scheme with SDL2 and OpenGL";
    license = lib.licenses.asl20;
    mainProgram = "chickadee";
    maintainers = with lib.maintainers; [ chito ] ;
    inherit (guile.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
