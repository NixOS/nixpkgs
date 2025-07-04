{
  lib,
  stdenv,
  fetchFromGitLab,
  udisks2,
  qt6,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcsys";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore";
    repo = "libcsys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-53vneIR2uy3VtbnOlEHl1anj3nXA3MU2KQt1PWm7KGI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qt6.qtbase
    udisks2
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Library for managing drive and getting system resource information in real time";
    homepage = "https://gitlab.com/cubocore/libcsys";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = lib.platforms.linux;
  };
})
