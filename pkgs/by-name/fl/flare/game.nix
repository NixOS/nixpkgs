{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flare-game";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = "flare-game";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IsVfP8wmrublAqoVix7gOA4u8CRmXdyNzagnaXyFsxc=";
  };

  patches = [ ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Fantasy action RPG using the FLARE engine";
    homepage = "https://github.com/flareteam/flare-game";
    maintainers = with lib.maintainers; [
      aanderse
      McSinyx
    ];
    license = [ lib.licenses.cc-by-sa-30 ];
    platforms = lib.platforms.unix;
  };
})
