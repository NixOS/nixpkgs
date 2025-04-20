{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  meson,
  ninja,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdocumentview";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "extraqt";
    repo = "qdocumentview";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fGm19Bl3lSvMhau2jByZTTThwfWnsrm/Xx82J6ZJcVo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.poppler
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Widget to render multi-page documents";
    mainProgram = "qdocumentview";
    homepage = "https://gitlab.com/extraqt/qdocumentview";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ emaryn ];
    platforms = lib.platforms.linux;
  };
})
