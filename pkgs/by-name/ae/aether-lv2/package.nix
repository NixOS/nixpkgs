{
  lib,
  stdenv,
  fetchFromGitHub,
  lv2,
  libx11,
  libGL,
  libGLU,
  libgbm,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aether-lv2";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Dougal-s";
    repo = "aether";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+sWfYpBnVFpo/9d7Ci7FJBXUQllKPeKAPsh2WTWBEXY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    lv2
    libx11
    libGL
    libGLU
    libgbm
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=array-bounds"
    "-Wno-error=stringop-overflow"
  ];

  installPhase = ''
    mkdir -p $out/lib/lv2
    cp -r aether.lv2 $out/lib/lv2
  '';

  meta = {
    homepage = "https://dougal-s.github.io/Aether/";
    description = "Algorithmic reverb LV2 based on Cloudseed";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
})
