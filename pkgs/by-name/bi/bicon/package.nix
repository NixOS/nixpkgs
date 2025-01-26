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

stdenv.mkDerivation (finalAttrs: {
  pname = "bicon";
  version = "0.5-unstable-2024-01-31";

  src = fetchFromGitHub {
    owner = "behdad";
    repo = "bicon";
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

  meta = {
    description = "Bidirectional console";
    homepage = "https://github.com/behdad/bicon";
    license = with lib.licenses; [
      lgpl21
      psfl
      bsd0
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
