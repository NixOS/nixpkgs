{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  lv2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "airwindows-lv2";
  version = "38.0";
  src = fetchFromSourcehut {
    owner = "~hannes";
    repo = "airwindows-lv2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M54HGcU1LxvV+KwOlnvI8gxeMxnCQ+2yAH8BPBM4/eg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ lv2 ];

  meta = {
    description = "Airwindows plugins (ported to LV2)";
    homepage = "https://sr.ht/~hannes/airwindows-lv2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.unix;
  };
})
