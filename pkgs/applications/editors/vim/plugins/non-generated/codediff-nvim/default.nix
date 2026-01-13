{
  lib,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  vimUtils,
  vimPlugins,
}:
vimUtils.buildVimPlugin rec {
  pname = "codediff.nvim";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "esmuellert";
    repo = "codediff.nvim";
    tag = "v${version}";
    hash = "sha256-hHBAGDWtw56gk1kWUtU9QEP2QqIATmPNeJ2lPD8dWIc=";
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
