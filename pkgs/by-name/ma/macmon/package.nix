{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "macmon";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "macmon";
    tag = "v${version}";
    hash = "sha256-aPCMKSWS3klTy4qvqi/Vft4nH95/eyXrN4CGkyS7OHc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-stSfXxQorNrktwOryqQ4TyT9Zqhyq9I9bntt07B1YBs=";

  meta = {
    homepage = "https://github.com/vladkens/macmon";
    description = "Sudoless performance monitoring for Apple Silicon processors";
    platforms = [ "aarch64-darwin" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ schrobingus ];
  };
}
