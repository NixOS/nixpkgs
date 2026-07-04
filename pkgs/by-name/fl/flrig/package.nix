{
  lib,
  stdenv,
  fetchurl,
  fltk_1_3,
  libjpeg,
  eudev,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "2.0.10";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/flrig-${version}.tar.gz";
    hash = "sha256-al8rh9T//tQQo1s6F2tdBOYO1N4/2lRQefNlbkLvQr0=";
  };

  buildInputs = [
    fltk_1_3
    libjpeg
    eudev
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  env.FLTK_CONFIG = lib.getExe' (lib.getDev fltk_1_3) "fltk-config";

  meta = {
    description = "Digital modem rig control program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
    mainProgram = "flrig";
  };
}
