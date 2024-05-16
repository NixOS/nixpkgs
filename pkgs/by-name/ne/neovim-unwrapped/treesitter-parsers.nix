{ fetchurl }:

{
  c = fetchurl {
    url = "https://github.com/tree-sitter/tree-sitter-c/archive/v0.20.2.tar.gz";
    hash = "sha256:af66fde03feb0df4faf03750102a0d265b007e5d957057b6b293c13116a70af2";
  };
  lua = fetchurl {
    url = "https://github.com/MunifTanjim/tree-sitter-lua/archive/v0.0.14.tar.gz";
    hash = "sha256:930d0370dc15b66389869355c8e14305b9ba7aafd36edbfdb468c8023395016d";
  };
  vim = fetchurl {
    url = "https://github.com/neovim/tree-sitter-vim/archive/v0.3.0.tar.gz";
    hash = "sha256:403acec3efb7cdb18ff3d68640fc823502a4ffcdfbb71cec3f98aa786c21cbe2";
  };
  vimdoc = fetchurl {
    url = "https://github.com/neovim/tree-sitter-vimdoc/archive/v2.0.0.tar.gz";
    hash = "sha256:1ff8f4afd3a9599dd4c3ce87c155660b078c1229704d1a254433e33794b8f274";
  };
  query = fetchurl {
    url = "https://github.com/nvim-treesitter/tree-sitter-query/archive/v0.1.0.tar.gz";
    hash = "sha256:e2b806f80e8bf1c4f4e5a96248393fe6622fc1fc6189d6896d269658f67f914c";
  };
}
