{ fetchFromGitHub }:

rec {
  c.src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-c";
    rev = "v0.23.4";
    hash = "sha256-nb+CoRbX7RFAGus7USWA1NhAnnkkJ89vIdSN36QmSCE=";
  };
  lua.src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-lua";
    rev = "v0.3.0";
    hash = "sha256-Gdic6m9uFVFTWq3XOMe0gTVnEYsX8oNoJG3niEG3KhA=";
  };
  vim.src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-vim";
    rev = "v0.5.0";
    hash = "sha256-UvH/k0gWEhrgxG1HnrdmaLHzygkaKk4hx2gK/6TZYNM=";
  };
  vimdoc.src = fetchFromGitHub {
    owner = "neovim";
    repo = "tree-sitter-vimdoc";
    rev = "v3.0.1";
    hash = "sha256-HHOUgQ9qV1nb2zEScRDwmvlE39XPmLxShlDeLuxID2s=";
  };
  query.src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-query";
    rev = "v0.5.1";
    hash = "sha256-uXApakOZy9Gd/fl9C9qFZgptlT6rUlOmT6KW8sWP5Ag=";
  };
  markdown.src = fetchFromGitHub {
    owner = "tree-sitter-grammars";
    repo = "tree-sitter-markdown";
    rev = "v0.4.1";
    hash = "sha256-Oe2iL5b1Cyv+dK0nQYFNLCCOCe+93nojxt6ukH2lEmU=";
  };
  markdown_inline.src = markdown.src;
}
