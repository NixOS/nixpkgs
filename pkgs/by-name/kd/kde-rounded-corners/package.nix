{
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  libepoxy,
  libxcb,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kde-rounded-corners";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dgeB+N0Ye/O5y/o/yc9Vj1Ia8d2uUOGjxBddyPHaDQc=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    wrapQtAppsHook
  ]);
  buildInputs =
    with kdePackages;
    [
      kcmutils
      kwin
      qtbase
    ]
    ++ [
      libepoxy
      libxcb
    ];

  meta = {
    description = "Rounds the corners of your windows";
    homepage = "https://github.com/matinlotfali/KDE-Rounded-Corners";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ devusb ];
  };
})
