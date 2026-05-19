{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

let
  common = import ./common.nix { inherit lib nix-update-script; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flare-game";
  inherit (common) version;

  src = fetchFromGitHub {
    owner = "flareteam";
    repo = "flare-game";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IsVfP8wmrublAqoVix7gOA4u8CRmXdyNzagnaXyFsxc=";
  };


  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Fantasy action RPG using the FLARE engine";
    homepage = "https://github.com/flareteam/flare-game";
    license = [ lib.licenses.cc-by-sa-30 ];
    platforms = lib.platforms.unix;
    inherit (common) maintainers;
  };
})
