{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  ninja,
  qt6,

  cairo,
  ffmpeg,
  ghostscript,
  glfw,
  libtiff,
  qhull,
  xercesc,
  xorg,
  zeromq,

  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "gr-framework";
  version = "0.73.8";

  src = fetchFromGitHub {
    owner = "sciapp";
    repo = "gr";
    rev = "v${version}";
    hash = "sha256-6RgNFGRprke7AUu24VS9iYUcWMWJ/DQ/LIvleyQgza4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    cairo
    ffmpeg
    ghostscript
    glfw
    libtiff
    qhull
    qt6.qtbase
    xercesc
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
    maintainers = with maintainers; [ paveloom ];
    platforms = platforms.unix;
  };
}
