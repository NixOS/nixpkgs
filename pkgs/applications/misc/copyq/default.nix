{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qtbase
, qtscript
, libXfixes
, libXtst
, qtx11extras
, git
, knotifications
, qtwayland
, wayland
, fetchpatch
}:

mkDerivation rec {
  pname = "CopyQ";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    rev = "v${version}";
    sha256 = "sha256-edrRgnjbszqJLbGLE4anCJSGApymvK0O+2ks5jWe8aw=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase
    qtscript
    libXfixes
    libXtst
    qtx11extras
    knotifications
    qtwayland
    wayland
  ];

  postPatch = ''
    substituteInPlace shared/com.github.hluk.copyq.desktop.in \
      --replace copyq "$out/bin/copyq"
  '';

  meta = with lib; {
    homepage = "https://hluk.github.io/CopyQ";
    description = "Clipboard Manager with Advanced Features";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ willtim artturin ];
    # NOTE: CopyQ supports windows and osx, but I cannot test these.
    # OSX build requires QT5.
    platforms = platforms.linux;
  };
}
