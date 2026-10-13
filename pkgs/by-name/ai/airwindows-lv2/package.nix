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
  version = "40.0";
  src = fetchFromSourcehut {
    owner = "~hannes";
    repo = "airwindows-lv2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o2xLp95CBqItYuwyu3Kcnz6pPB+LU+vhVqyyoqwW10s=";
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
