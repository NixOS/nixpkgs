{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "material-kwin-decoration";
  version = "7-unstable-2023-01-15";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = "material-decoration";
    rev = "0e989e5b815b64ee5bca989f983da68fa5556644";
    hash = "sha256-Ncn5jxkuN4ZBWihfycdQwpJ0j4sRpBGMCl6RNiH4mXg=";
  };

  # Remove -Werror since it uses deprecated methods
  postPatch = ''
    substituteInPlace ./CMakeLists.txt \
      --replace "add_definitions (-Wall -Werror)" "add_definitions (-Wall)"
  '';

  nativeBuildInputs = [
    cmake
  ]
  ++ (with libsForQt5; [
    extra-cmake-modules
    wrapQtAppsHook
  ]);

  buildInputs = with libsForQt5; [
    qtx11extras
    kcoreaddons
    kguiaddons
    kdecoration
    kconfig
    kconfigwidgets
    kwindowsystem
    kiconthemes
    kwayland
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
  };

  meta = {
    description = "Material-ish window decoration theme for KWin";
    homepage = "https://github.com/Zren/material-decoration";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
