{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-emojicodes";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "blyxyas";
    repo = "mdbook-emojicodes";
    rev = "${version}";
    hash = "sha256-dlvfY2AMBvTl0j9YaT+u4CeWQGGihFD8AZaAK4/hUWU=";
  };

  cargoHash = "sha256-+VVkrXvsqtizeVhfuO0U8ADfSkmovpT7DVwrz7QljU0=";

  meta = {
    description = "MDBook preprocessor for converting emojicodes (e.g. `: cat :`) into emojis";
    mainProgram = "mdbook-emojicodes";
    homepage = "https://github.com/blyxyas/mdbook-emojicodes";
    changelog = "https://github.com/blyxyas/mdbook-emojicodes/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
}
