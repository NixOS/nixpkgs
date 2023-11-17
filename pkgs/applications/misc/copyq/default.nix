{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
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
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    hash = "sha256-aAmpFKIIFZLPWUaOcf4V1d/wVQ7xRcnXFsqFjROsabg=";
  };

  patches = [
    # itemfakevim: fix build with qt 6.6.0
    # https://github.com/hluk/CopyQ/pull/2508
    (fetchpatch2 {
      url = "https://github.com/hluk/CopyQ/commit/a20bfff0d78296b334ff8cabb047ab5d842b7311.patch";
      hash = "sha256-F/6cQ8+O1Ttd4EFFxQas5ES6U+qxWdmYqUWRQLsVMa4=";
    })
  ];

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
