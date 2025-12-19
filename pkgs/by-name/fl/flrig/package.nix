{
  lib,
  stdenv,
  fetchurl,
  fltk13,
  libjpeg,
  eudev,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "2.0.10";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-al8rh9T//tQQo1s6F2tdBOYO1N4/2lRQefNlbkLvQr0=";
  };

  buildInputs = [
    fltk13
    libjpeg
    eudev
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  env.FLTK_CONFIG = lib.getExe' (lib.getDev fltk13) "fltk-config";

  meta = {
    description = "Digital modem rig control program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
    mainProgram = "flrig";
  };
}
