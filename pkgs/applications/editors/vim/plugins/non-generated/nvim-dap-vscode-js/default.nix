{
  pkgs,
  fetchFromGitHub,
  vimUtils
}:
vimUtils.buildVimPlugin {
  pname = "nvim-dap-vscode-js";
  version = "v1.1.0";

  src = fetchFromGitHub {
    owner = "mxsdev";
    repo = "nvim-dap-vscode-js";
    rev = "v1.1.0";
    sha256 = "sha256-lZABpKpztX3NpuN4Y4+E8bvJZVV5ka7h8x9vL4r9Pjk=";
  };

  dependencies = with pkgs.vimPlugins; [
    vscode-js-debug
    nvim-dap
  ];
}
