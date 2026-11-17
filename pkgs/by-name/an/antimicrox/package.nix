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
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "AntiMicroX";
    repo = "antimicrox";
    rev = finalAttrs.version;
    sha256 = "sha256-Hy0AHg3foZnIbN4Xx8kwYhbg+Z+cjdop6lYdgYPRyts=";
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
