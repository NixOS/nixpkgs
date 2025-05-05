{
  lib,
  stdenv,
  autoconf,
  automake,
  expat,
  fetchFromGitHub,
  libfakekey,
  libtool,
  libXft,
  pkg-config,
  xorg,
}:

stdenv.mkDerivation {
  pname = "matchbox-keyboard";
  version = "5f6aa66";

  src = fetchFromGitHub {
    owner = "mwilliams03";
    repo = "matchbox-keyboard";
    rev = "5f6aa668bfe8fa26af0524e45893832fb804541d";
    hash = "sha256-XDs6EYYwCTgNTNQN4Q1mkH1j0DAMwZD9axsjV9qqXo4=";
  };

  patches = [
    ./implicit-functions.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    expat
    libfakekey
    libtool
    libXft
    pkg-config
    xorg.libXtst
    xorg.libXi
  ];

  postUnpack = ''
    autoreconf -v --install source
  '';

  meta = with lib; {
    description = "Matchbox-keyboard is an on screen 'virtual' or 'software' keyboard";
    homepage = "https://github.com/mwilliams03/matchbox-keyboard";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ camelpunch ];
    platforms = platforms.linux;
  };
}
