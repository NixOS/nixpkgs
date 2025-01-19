{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  lv2,
}:

stdenv.mkDerivation rec {
  pname = "airwindows-lv2";
  version = "28.0";
  src = fetchFromSourcehut {
    owner = "~hannes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1GWkdNCn98ttsF2rPLZE0+GJdatgkLewFQyx9Frr2sM=";
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
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.unix;
  };
}
