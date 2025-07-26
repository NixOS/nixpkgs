{
  lib,
  fetchFromGitHub,
  rustPlatform,
  graphviz,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-graphviz";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dylanowen";
    repo = "mdbook-graphviz";
    # Upstream has rewritten tags before:
    # https://github.com/dylanowen/mdbook-graphviz/issues/180
    rev = "6e368ad745934fb9e10f224cfc0dc15d4f6fa114";
    hash = "sha256-f02SOyU5REm+uP4/vB/1yG9M0Vg8ShF2hj5NKuh0jLU=";
  };

  cargoHash = "sha256-A1pFifxshWynwA88iLTMOm21NKCH8fHl5nFiV4wEG8A=";

  nativeCheckInputs = [ graphviz ];

  meta = {
    description = "Preprocessor for mdbook, rendering Graphviz graphs to HTML at build time";
    mainProgram = "mdbook-graphviz";
    homepage = "https://github.com/dylanowen/mdbook-graphviz";
    changelog = "https://github.com/dylanowen/mdbook-graphviz/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      lovesegfault
      matthiasbeyer
    ];
  };
}
