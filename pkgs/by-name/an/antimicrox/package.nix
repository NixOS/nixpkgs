{
  lib,
  stdenv,
  cmake,
  kdePackages,
  pkg-config,
  itstool,
  udevCheckHook,
  SDL2,
  libsForQt5,
  libxtst,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "antimicrox";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "AntiMicroX";
    repo = "antimicrox";
    rev = finalAttrs.version;
    sha256 = "sha256-frPXUTbD5Wk0Wo8E9L8Es5GCvWY55Qx0RGSkYDaVs6g=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    itstool
    udevCheckHook
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    libsForQt5.qttools
    libxtst
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
        --replace "/usr/lib/udev/rules.d/" "$out/lib/udev/rules.d/"
  '';

  doInstallCheck = true;

  meta = {
    description = "GUI for mapping keyboard and mouse controls to a gamepad";
    inherit (finalAttrs.src.meta) homepage;
    maintainers = [ ];
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux;
    mainProgram = "antimicrox";
  };
})
