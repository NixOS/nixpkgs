{ fetchurl }:

{
  c.src = fetchurl {
    url = "https://github.com/tree-sitter/tree-sitter-c/archive/v0.23.4.tar.gz";
    hash = "sha256:b66c5043e26d84e5f17a059af71b157bcf202221069ed220aa1696d7d1d28a7a";
  };
  lua.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/v0.3.0.tar.gz";
    hash = "sha256:a34cc70abfd8d2d4b0fabf01403ea05f848e1a4bc37d8a4bfea7164657b35d31";
  };
  vim.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/v0.5.0.tar.gz";
    hash = "sha256:90019d12d2da0751c027124f27f5335babf069a050457adaed53693b5e9cf10a";
  };
  vimdoc.src = fetchurl {
    url = "https://github.com/neovim/tree-sitter-vimdoc/archive/v3.0.1.tar.gz";
    hash = "sha256:76b65e5bee9ff78eb21256619b1995aac4d80f252c19e1c710a4839481ded09e";
  };
  query.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/v0.5.1.tar.gz";
    hash = "sha256:fe8c712880a529d454347cd4c58336ac2db22243bae5055bdb5844fb3ea56192";
  };
  markdown.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v0.4.1.tar.gz";
    hash = "sha256:e0fdb2dca1eb3063940122e1475c9c2b069062a638c95939e374c5427eddee9f";
  };
}
