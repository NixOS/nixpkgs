{ fetchurl }:

{
  c.src = fetchurl {
    url = "https://github.com/tree-sitter/tree-sitter-c/archive/v0.21.0.tar.gz";
    hash = "sha256:6f0f5d1b71cf8ffd8a37fb638c6022fa1245bd630150b538547d52128ce0ea7e";
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
    url = "https://github.com/neovim/tree-sitter-vimdoc/archive/v2.5.1.tar.gz";
    hash = "sha256:063645096504b21603585507c41c6d8718ff3c11b2150c5bfc31e8f3ee9afea3";
  };
  query.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/v0.3.0.tar.gz";
    hash = "sha256:f878ff37abcb83250e31a6569e997546f3dbab74dcb26683cb2d613f7568cfc0";
  };
  python.src = fetchurl {
    url = "https://github.com/tree-sitter/tree-sitter-python/archive/v0.21.0.tar.gz";
    hash = "sha256:720304a603271fa89e4430a14d6a81a023d6d7d1171b1533e49c0ab44f1e1c13";
  };
  bash.src = fetchurl {
    url = "https://github.com/tree-sitter/tree-sitter-bash/archive/v0.21.0.tar.gz";
    hash = "sha256:f0515efda839cfede851adb24ac154227fbc0dfb60c6c11595ecfa9087d43ceb";
  };
  markdown.src = fetchurl {
    url = "https://github.com/MDeiml/tree-sitter-markdown/archive/v0.2.3.tar.gz";
    hash = "sha256:4909d6023643f1afc3ab219585d4035b7403f3a17849782ab803c5f73c8a31d5";
  };
}
