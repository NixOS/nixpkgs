{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eta";
  version = "1.0.1-unstable-2026-01-04";

  src = fetchFromGitHub {
    owner = "aioobe";
    repo = "eta";
    rev = "7027a4012e7c697be1c9af1a9f21bfae1bd4913b";
    hash = "sha256-18TOXDohyRGA0pmRyWgR9EPhKgZt+ZtkuTCFWbSnFlY=";
  };

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "Tool for monitoring progress and ETA of an arbitrary process";
    homepage = "https://github.com/aioobe/eta";
    license = lib.licenses.gpl3Only;
    mainProgram = "eta";
    maintainers = with lib.maintainers; [ heisfer ];
    platforms = lib.platforms.linux;
  };
})
