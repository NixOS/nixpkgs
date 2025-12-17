{
  lib,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  vimUtils,
  vimPlugins,
}:
vimUtils.buildVimPlugin rec {
  pname = "vscode-diff.nvim";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "esmuellert";
    repo = "vscode-diff.nvim";
    tag = "v${version}";
    hash = "sha256-FyfVmxX40hAk1ch1PWtNi3FszAKfDk7XKEpnZfBw4I4=";
  };

  dependencies = [ vimPlugins.nui-nvim ];

  nativeBuildInputs = [ cmake ];
  dontUseCmakeConfigure = true;
  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "VSCode-style side-by-side diff rendering with two-tier highlighting (line + character level)";
    homepage = "https://github.com/esmuellert/vscode-diff.nvim/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
