{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "v${version}";
    hash = "sha256-lpaE1yb9Yt1AVpZWBnvDOjTpVeKdTlXDnqNDrF0fCZ8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7XXNNVATIrpUdse1JfIlHazx2DxkuDBtGgdJuF+D6jI=";

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "harper-cli";
  };
}
