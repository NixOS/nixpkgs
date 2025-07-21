{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXinerama,
  libXrandr,
  libXft,
  bison,
  pkg-config,
}:

stdenv.mkDerivation rec {

  pname = "cwm";
  version = "7.4";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "cwm";
    rev = "v${version}";
    hash = "sha256-L3u4mH2UH2pTHhSPVr5dUi94b9DheslkIWL6EgQ05yA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    bison
  ];
  buildInputs = [
    libX11
    libXinerama
    libXrandr
    libXft
  ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = with lib; {
    description = "Lightweight and efficient window manager for X11";
    homepage = "https://github.com/leahneukirchen/cwm";
    maintainers = with maintainers; [
      _0x4A6F
      mkf
    ];
    license = licenses.isc;
    platforms = platforms.linux;
    mainProgram = "cwm";
  };
}
