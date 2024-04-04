{ lib, rustPlatform, fetchpatch, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "mini-calc";
  version = "2.12.2";

  src = fetchFromGitHub {
    owner = "coco33920";
    repo = "calc";
    rev = version;
    hash = "sha256-MKMZVRjqwNQUNkuduvgVvsp53E48JPI68Lq/6ooLcFc=";
  };

  cargoHash = "sha256-A9t7i9mw4dzCWUAObZ81BSorCrzx6wEjYXiRWIBzM9M=";
  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/coco33920/calc/commit/0bd12cbf3e13e447725e22cc70df72e559d21c94.patch";
      sha256 = "sha256-1QN18LQFh8orh9DvgLBGAHimW/b/8HxbwtVD9s7mQaI=";
    })
  ];

  meta = {
    description = "A fully-featured minimalistic configurable calculator written in Rust";
    changelog = "https://github.com/coco33920/calc/blob/${version}/CHANGELOG.md";
    homepage = "https://calc.nwa2coco.fr";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "mini-calc";
    platforms = lib.platforms.unix;
  };
}
