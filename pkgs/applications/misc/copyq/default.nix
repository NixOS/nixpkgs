{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

stdenv.mkDerivation rec {
  pname = "CopyQ";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    hash = "sha256-wxjUL5mGXAMNVGP+dAh1NrE9tw71cJW9zmLsaCVphTo=";
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
    kdePackages.kguiaddons
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_QT6" true)
  ];

  patches = [
    # https://github.com/hluk/CopyQ/pull/3268
    (fetchpatch2 {
      url = "https://github.com/hluk/CopyQ/commit/103903593c37c9db5406d276e0097fbf18d2a8c4.patch?full_index=1";
      hash = "sha256-zywE6ntMw+WvTyilXwvd4lfQRAAB9R/AGpwtwwPFZZE=";
    })
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
}
