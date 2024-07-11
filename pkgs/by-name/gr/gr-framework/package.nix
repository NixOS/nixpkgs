{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, qt5

, cmake

, cairo
, ffmpeg
, freetype
, ghostscript
, glfw
, libjpeg
, libtiff
, qhull
, xorg
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "gr-framework";
  version = "0.73.5";

  src = fetchFromGitHub {
    owner = "sciapp";
    repo = "gr";
    rev = "v${version}";
    hash = "sha256-9Py2r774GaUXWhF3yO3ceT1rPi/uqMVZVAo0xs9n+I0=";
  };

  patches = [
    ./patches/use-the-module-mode-to-search-for-the-LibXml2-package.patch
  ];

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    cairo
    ffmpeg
    freetype
    ghostscript
    glfw
    libjpeg
    libtiff
    qhull
    qt5.qtbase
    xorg.libX11
    xorg.libXft
    xorg.libXt
    zeromq
  ];

  preConfigure = ''
    echo ${version} > version.txt
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "GR framework is a graphics library for visualisation applications";
    homepage = "https://gr-framework.org";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ paveloom ];
  };
}
