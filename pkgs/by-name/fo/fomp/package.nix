{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch2,
  lv2,
  lv2lint,
  pkg-config,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "fomp";
  version = "1.2.4";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "fomp";
    tag = "v${version}";
    hash = "sha256-8rkAV+RJS9vQV+9+swclAP0QBjBDT2tKeLWHxwpUrlk=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://gitlab.com/drobilla/fomp/-/commit/f8e4e1e0b1abe3afd2ea17b13795bbe871fccece.patch";
      hash = "sha256-uJpUwTEBOp0Zo7zKT9jekhtkg9okUvGTavLIQmNKutU=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    lv2lint
  ];

  buildInputs = [
    lv2
  ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://drobilla.net/software/fomp.html";
    description = "LV2 port of the MCP, VCO, FIL, and WAH plugins by Fons Adriaensen";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
