{
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  kdePackages,
  libepoxy,
  libxcb,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "kde-rounded-corners";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    rev = "v${version}";
    hash = "sha256-ef63PVG0JOHY4zyq5M5oAAcxtfhm1XOvpsxgSeXvgDo=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/matinlotfali/KDE-Rounded-Corners/commit/5d63212e65ed06ca65a2a7f0ad2436045b839ddd.patch";
      hash = "sha256-wfjxMKRmJu3gflldNvWLghw5oFyyxY2ml1lsl/TVzxI=";
    })
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];
  buildInputs = [
    kdePackages.kcmutils
    kdePackages.kwin
    libepoxy
    libxcb
    kdePackages.qtbase
  ];

  meta = {
    description = "Rounds the corners of your windows";
    homepage = "https://github.com/matinlotfali/KDE-Rounded-Corners";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ devusb ];
  };
}
