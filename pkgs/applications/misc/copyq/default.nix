{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, extra-cmake-modules
, qtbase
, qtsvg
, qttools
, qtdeclarative
, libXfixes
, libXtst
, qtwayland
, wayland
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "CopyQ";
<<<<<<< HEAD
  version = "7.1.0";
=======
  version = "unstable-2023-04-14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-aAmpFKIIFZLPWUaOcf4V1d/wVQ7xRcnXFsqFjROsabg=";
=======
    rev = "c4e481315be5a1fa35503c9717b396319b43aa9b";
    hash = "sha256-XLuawTKzDi+ixEUcsllyW5tCVTPlzIozu1UzYOjTqDU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    ninja
    extra-cmake-modules
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
