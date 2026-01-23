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
  version = "34.0";
  src = fetchFromSourcehut {
    owner = "~hannes";
    repo = "airwindows-lv2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BLoDQ02DbTTaJ7UPh1eqSrgWe9t9PbDdgylBOI0ENGQ=";
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
