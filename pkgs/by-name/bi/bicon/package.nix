{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  perl,
  fribidi,
  kbd,
  xkbutils,
}:

stdenv.mkDerivation rec {
  pname = "bicon";
  version = "unstable-2024-01-31";

  src = fetchFromGitHub {
    owner = "behdad";
    repo = pname;
    rev = "48720c0f22197d4d5f7b0f5162a3d8f071e6e8a8";
    hash = "sha256-4pvI4T+fdgCirHDc0h3vP5AZyqfnBKv5R3fJICnpmF4=";
  };

  buildInputs = [
    fribidi
    kbd
    xkbutils
    perl
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preConfigure = ''
    patchShebangs .
  '';

  meta = with lib; {
    description = "Bidirectional console";
    homepage = "https://github.com/behdad/bicon";
    license = [
      licenses.lgpl21
      licenses.psfl
      licenses.bsd0
    ];
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
