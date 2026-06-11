{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-pagetoc";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "slowsage";
    repo = "mdbook-pagetoc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-B94lIgOJC83cIkuggmfopTDEi9CUQ3nJJpzF9LdImUA=";
  };

  cargoHash = "sha256-CazBgtNh4Z2wlfh9q0SjLsn70zh+aEg957Zq0kh45Hc=";

  meta = {
    description = "Table of contents for mdbook (in sidebar)";
    mainProgram = "mdbook-pagetoc";
    homepage = "https://github.com/slowsage/mdbook-pagetoc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
