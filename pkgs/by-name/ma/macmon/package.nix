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

  cargoHash = "sha256-mE6PGWjaCFpqVoE1zISOqwt6o5SakjJM4sPRtU90lPA=";

  meta = {
    homepage = "https://github.com/vladkens/macmon";
    description = "Sudoless performance monitoring for Apple Silicon processors";
    platforms = [ "aarch64-darwin" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ schrobingus ];
  };
}
