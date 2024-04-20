{ lib, rustPlatform, fetchpatch, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "mini-calc";
  version = "2.12.3";

  src = fetchFromGitHub {
    owner = "coco33920";
    repo = "calc";
    rev = version;
    hash = "sha256-/aTfh3d63wwk3xai2F/D1fMJiDO4mg+OeLIanV4vSuA=";
  };

  cargoHash = "sha256-BfaOhEAKZmTYkzz6rvcSmDPufyQMJFtQO6CRksgA/2U=";
  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/coco33920/calc/commit/a010c72b5c06c75b7f644071f2861394dd5c74b8.patch";
      sha256 = "sha256-ceyxfgiXHS+oOJ4apM8+cSjMICwGlQHMKjFICATmKTU=";
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
