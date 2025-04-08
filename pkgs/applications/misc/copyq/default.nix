{
  lib,
  stdenv,
  fetchFromGitHub,
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
  wrapQtAppsHook,
  kdePackages,
}:

stdenv.mkDerivation rec {
  pname = "CopyQ";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    hash = "sha256-WBJyLfiPPEQ/Cj5uuwy9KhVc1kw4Hv5TeEuRFDydlGk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    wrapQtAppsHook
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

  postPatch = ''
    substituteInPlace shared/com.github.hluk.copyq.desktop.in \
      --replace copyq "$out/bin/copyq"
  '';

  cmakeFlags = [ "-DWITH_QT6=ON" ];

  meta = with lib; {
    homepage = "https://hluk.github.io/CopyQ";
    description = "Clipboard Manager with Advanced Features";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ artturin ];
    # NOTE: CopyQ supports windows and osx, but I cannot test these.
    platforms = platforms.linux;
    mainProgram = "copyq";
  };
}
