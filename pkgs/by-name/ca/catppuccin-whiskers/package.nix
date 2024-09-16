{ lib, fetchFromGitHub, rustPlatform }:
let version = "2.5.0";
in rustPlatform.buildRustPackage {
  pname = "catppuccin-whiskers";
  inherit version;

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "whiskers";
    rev = "refs/tags/v${version}";
    hash = "sha256-HsHBMJPSoDhSNwjAR7LbFG4Za4H2H+7itqgiKRdb4M8=";
  };

  cargoHash = "sha256-FpBgXP4kXSzrYP+ad+KubUG4NSDpyoaJwyReS86ETy8=";

  meta = {
    homepage = "https://github.com/catppuccin/whiskers";
    description = "A templating tool to simplify the creation of Catppuccin ports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Name ];
    mainProgram = "whiskers";
  };
}
