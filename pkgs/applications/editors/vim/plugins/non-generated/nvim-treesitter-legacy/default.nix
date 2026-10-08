{ vimUtils, fetchFromGitHub }:
vimUtils.buildVimPlugin {
  pname = "nvim-treesitter-legacy";
  version = "0.10.0-unstable-2025-05-24";
  src = fetchFromGitHub {
    owner = "nvim-treesitter";
    repo = "nvim-treesitter";
    rev = "42fc28ba918343ebfd5565147a42a26580579482";
    hash = "sha256-CVs9FTdg3oKtRjz2YqwkMr0W5qYLGfVyxyhE3qnGYbI=";
  };
  meta.homepage = "https://github.com/nvim-treesitter/nvim-treesitter/";
  meta.hydraPlatforms = [ ];
}
