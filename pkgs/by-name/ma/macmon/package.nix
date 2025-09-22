{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "macmon";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "macmon";
    rev = "v${version}";
    hash = "sha256-GiSF5PBRUcKZzd9vWf9MmKKZbtqchnu0DjFgbXmp7bg=";
  };

  cargoHash = "sha256-b9CpHSC3/kj7lHs+QhDqnRZfda9rtJJEs3j24NDZSPQ=";

  meta = {
    homepage = "https://github.com/vladkens/macmon";
    description = "Sudoless performance monitoring for Apple Silicon processors";
    platforms = [ "aarch64-darwin" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ schrobingus ];
  };
}
