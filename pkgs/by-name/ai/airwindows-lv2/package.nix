{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  lv2,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "airwindows-lv2";
  version = "34.0";
  src = fetchFromSourcehut {
    owner = "~hannes";
    repo = "airwindows-lv2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BLoDQ02DbTTaJ7UPh1eqSrgWe9t9PbDdgylBOI0ENGQ=";
=======
stdenv.mkDerivation rec {
  pname = "airwindows-lv2";
  version = "28.0";
  src = fetchFromSourcehut {
    owner = "~hannes";
    repo = "airwindows-lv2";
    rev = "v${version}";
    sha256 = "sha256-1GWkdNCn98ttsF2rPLZE0+GJdatgkLewFQyx9Frr2sM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
<<<<<<< HEAD

  buildInputs = [ lv2 ];

  meta = {
    description = "Airwindows plugins (ported to LV2)";
    homepage = "https://sr.ht/~hannes/airwindows-lv2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.unix;
  };
})
=======
  buildInputs = [ lv2 ];

  meta = with lib; {
    description = "Airwindows plugins (ported to LV2)";
    homepage = "https://sr.ht/~hannes/airwindows-lv2";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
