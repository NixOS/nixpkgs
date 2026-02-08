{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "complgen";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5fEownFj5cyLL+4ZPN80qlkw3xu6xspsKfruk7KBhrI=";
  };

  cargoHash = "sha256-wGbf1UiCwjOzUbR0k45EAuGjEg9+x14d8kKpz7pHQN8=";

  meta = {
    changelog = "https://github.com/adaszko/complgen/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    license = lib.licenses.asl20;
    mainProgram = "complgen";
    maintainers = with lib.maintainers; [ hythera ];
  };
})
