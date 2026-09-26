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
  version = "2.0.12";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/flrig-${version}.tar.gz";
    hash = "sha256-wW3AB7aOe+Xas2M4EIXQvFyIQpBhFuzZ4W7nXJ1azL8=";
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
