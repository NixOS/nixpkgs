{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  qtbase,
  qtsvg,
  qttools,
  qtdeclarative,
  libXfixes,
  libXtst,
  qtwayland,
  wayland,
  pkg-config,
  wrapQtAppsHook,
  kdePackages,
}:

stdenv.mkDerivation (rec {
  pname = "CopyQ";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    hash = "sha256-lH3WJ6cK2eCnmcLVLnYUypABj73UZjGqqDPp92QE+V4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qtbase
    qtsvg
    qttools
    qtdeclarative
    libXfixes
    libXtst
    qtwayland
    wayland
    kdePackages.kconfig
    kdePackages.kstatusnotifieritem
    kdePackages.knotifications
  ];

  patches = [
    (fetchpatch {
      # Can be removed after next release
      name = "fix-qchar-construction-for-qt-6.9.patch";
      url = "https://github.com/hluk/CopyQ/commit/f08c0d46a239362c5d3525ef9c3ba943bb00f734.patch";
      hash = "sha256-dsDIUVJHFFqzZ3tFOcYdwol/tm4viHM0CRs6wYfVKbQ=";
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_QT6" true)
  ];

  meta = {
    homepage = "https://hluk.github.io/CopyQ";
    description = "Clipboard Manager with Advanced Features";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ artturin ];
    # NOTE: CopyQ supports windows and osx, but I cannot test these.
    platforms = lib.platforms.linux;
    mainProgram = "copyq";
  };
})
