{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "macmon";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "macmon";
    rev = "v${version}";
    hash = "sha256-Uc+UjlCeG7W++l7d/3tSkIVbUi8IbNn3A5fqyshG+xE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-erKN6wR/W48QF1FbUkzjo6xaN1GVbAelruzxf4NS07o=";

  meta = {
    homepage = "https://github.com/vladkens/macmon";
    description = "Sudoless performance monitoring for Apple Silicon processors";
    platforms = [ "aarch64-darwin" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ schrobingus ];
  };
}
