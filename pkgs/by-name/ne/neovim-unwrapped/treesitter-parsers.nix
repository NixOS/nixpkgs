{ fetchurl }:

{
  c.src = fetchurl {
    url = "https://github.com/tree-sitter/tree-sitter-c/archive/v0.21.3.tar.gz";
    hash = "sha256:75a3780df6114cd37496761c4a7c9fd900c78bee3a2707f590d78c0ca3a24368";
  };
  lua.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/v0.1.0.tar.gz";
    hash = "sha256:230cfcbfa74ed1f7b8149e9a1f34c2efc4c589a71fe0f5dc8560622f8020d722";
  };
  vim.src = fetchurl {
    url = "https://github.com/neovim/tree-sitter-vim/archive/v0.4.0.tar.gz";
    hash = "sha256:9f856f8b4a10ab43348550fa2d3cb2846ae3d8e60f45887200549c051c66f9d5";
  };
  vimdoc.src = fetchurl {
    url = "https://github.com/neovim/tree-sitter-vimdoc/archive/v3.0.0.tar.gz";
    hash = "sha256:a639bf92bf57bfa1cdc90ca16af27bfaf26a9779064776dd4be34c1ef1453f6c";
  };
  query.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/v0.4.0.tar.gz";
    hash = "sha256:d3a423ab66dc62b2969625e280116678a8a22582b5ff087795222108db2f6a6e";
  };
  markdown.src = fetchurl {
    url = "https://github.com/MDeiml/tree-sitter-markdown/archive/v0.2.3.tar.gz";
    hash = "sha256:4909d6023643f1afc3ab219585d4035b7403f3a17849782ab803c5f73c8a31d5";
  };
}
