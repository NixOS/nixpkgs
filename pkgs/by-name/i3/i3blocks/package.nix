{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "i3blocks";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks";
    rev = "3417602a2d8322bc866861297f535e1ef80b8cb0";
    hash = "sha256-W3MQFZw44EbJ7Gp9rCxp1Me0iB5k5o1tN/t+jKrlFW0=";
  };

  patches = [
    # XDG_CONFIG_DIRS can contain multiple elements separated by colons, which should be searched in order.
    (fetchpatch {
      # https://github.com/vivien/i3blocks/pull/405
      url = "https://github.com/edef1c/i3blocks/commit/d57b32f9a364aeaf36869efdd54240433c737e57.patch";
      hash = "sha256-QT47Gvh5M/UjiOpHL9yfbDZwyFPuP/GbQK9C0BVYXYA=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = {
    description = "Flexible scheduler for your i3bar blocks";
    mainProgram = "i3blocks";
    homepage = "https://github.com/vivien/i3blocks";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; freebsd ++ linux;
  };
}
