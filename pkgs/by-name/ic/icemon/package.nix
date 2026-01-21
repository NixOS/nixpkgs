{
  lib,
  stdenv,
  asciidoc,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  icecream,
  libcap_ng,
  lzo,
  qt6,
  zstd,
  libarchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icemon";
  version = "3.3-unstable-2025-05-15";

  src = fetchFromGitHub {
    owner = "icecc";
    repo = "icemon";
    rev = "d0969453c7d4467e22dcff0f218b31e81136afbe";
    hash = "sha256-jN374J8PytnZgVEUSZ6DakmPmi411ABJffzuZ5CodJ8=";
  };

  nativeBuildInputs = [
    asciidoc
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    icecream
    qt6.qtbase
    libcap_ng
    lzo
    zstd
    libarchive
  ];

  meta = {
    description = "Icecream GUI Monitor";
    homepage = "https://github.com/icecc/icemon";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ emantor ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "icemon";
  };
})
