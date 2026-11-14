{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  libsndfile,
  lilv,
  lv2,
  pkg-config,
  serd,
  sord,
  sratom,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lv2bm";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "mod-audio";
    repo = "lv2bm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gC5/sP4G/S2qGRJGmDrSxvibzvJxBv2Vc3X9tFy/l24=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    libsndfile
    lilv
    lv2
    serd
    sord
    sratom
  ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    homepage = "https://github.com/portalmod/lv2bm";
    description = "Benchmark tool for LV2 plugins";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "lv2bm";
  };
})
