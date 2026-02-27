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
    owner = "moddevices";
    repo = "lv2bm";
    rev = "v${finalAttrs.version}";
    sha256 = "0vlppxfb9zbmffazs1kiyb79py66s8x9hihj36m2vz86zsq7ybl0";
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
