{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "elijah-potter";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-33UMN5OQ0h4HiSwFCIHyHo0oHiTlBfSmMxIQboLVzTY=";
  };

  cargoHash = "sha256-p/zTja6YSBTJNyyfuVi1jIfBmNdjJ11mcvEpyjxDwDo=";

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/elijah-potter/harper";
    changelog = "https://github.com/elijah-potter/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "harper-cli";
  };
}
