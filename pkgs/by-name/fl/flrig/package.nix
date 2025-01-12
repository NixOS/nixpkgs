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
  version = "2.0.05";
  pname = "flrig";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-Mc3AJfBdtIn9m6CH602Mj4UWj8OqnPlf5IiwLXgMYrA=";
  };

  buildInputs = [
    fltk13
    libjpeg
    eudev
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Digital modem rig control program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
    mainProgram = "flrig";
  };
}
