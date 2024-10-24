{ fetchurl }:

{
  c.src = fetchurl {
    url = "https://github.com/tree-sitter/tree-sitter-c/archive/v0.23.0.tar.gz";
    hash = "sha256:ee58c925e2e507c23d735aad46bf7fb0af31ca06d6f4f41bc008216d9232b0cb";
  };
  lua.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/v0.2.0.tar.gz";
    hash = "sha256:6c41227cd0a59047b19d31f0031d4d901f08bfd78d6fc7f55c89e5b8374c794e";
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
    url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v0.3.2.tar.gz";
    hash = "sha256:5dac48a6d971eb545aab665d59a18180d21963afc781bbf40f9077c06cb82ae5";
  };
}
