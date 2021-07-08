{lib}:
rec {
  tools = import ./tools.nix {inherit lib;};
  debian = import ./debian.nix {inherit lib tools;};
  number = with tools; mkVersioner levenCode;
}
