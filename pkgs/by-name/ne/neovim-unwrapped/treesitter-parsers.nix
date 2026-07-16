{ fetchurl }:

{
  c.src = fetchurl {
    url = "https://github.com/tree-sitter/tree-sitter-c/archive/v0.24.1.tar.gz";
    hash = "sha256:25dd4bb3dec770769a407e0fc803f424ce02c494a56ce95fedc525316dcf9b48";
  };
  lua.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/v0.5.0.tar.gz";
    hash = "sha256:cf01b93f4b61b96a6d27942cf28eeda4cbce7d503c3bef773a8930b3d778a2d9";
  };
  vim.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/v0.8.1.tar.gz";
    hash = "sha256:93cafb9a0269420362454ace725a118ff1c3e08dcdfdc228aa86334b54d53c2a";
  };
  vimdoc.src = fetchurl {
    url = "https://github.com/neovim/tree-sitter-vimdoc/archive/v4.1.0.tar.gz";
    hash = "sha256:020e8f117f648c8697fca967995c342e92dbd81dab137a115cc7555207fbc84f";
  };
  query.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-query/archive/v0.8.0.tar.gz";
    hash = "sha256:c2b23b9a54cffcc999ded4a5d3949daf338bebb7945dece229f832332e6e6a7d";
  };
  markdown.src = fetchurl {
    url = "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/v0.5.3.tar.gz";
    hash = "sha256:df845b1ab7c7c163ec57d7fa17170c92b04be199bddab02523636efec5224ab6";
  };
}
