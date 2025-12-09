{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pagetoc";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "slowsage";
    repo = "mdbook-pagetoc";
    rev = "v${version}";
    hash = "sha256-B94lIgOJC83cIkuggmfopTDEi9CUQ3nJJpzF9LdImUA=";
  };

  cargoHash = "sha256-CazBgtNh4Z2wlfh9q0SjLsn70zh+aEg957Zq0kh45Hc=";

  meta = with lib; {
    description = "Table of contents for mdbook (in sidebar)";
    mainProgram = "mdbook-pagetoc";
    homepage = "https://github.com/slowsage/mdbook-pagetoc";
    license = licenses.mit;
    maintainers = with maintainers; [
      matthiasbeyer
    ];
  };
}
