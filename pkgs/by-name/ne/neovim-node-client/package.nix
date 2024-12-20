{
  lib,
  buildNpmPackage,
  fetchNpmDeps,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "node-client";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "node-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-0vPw2hCGUDepSpF1gp/lI71EgwGsCSnw7ePP7ElHsTQ=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-VYoJAi1RzVf5ObjuGmnuiA/1WYBWC+qYPdfWF98+oGw=";
  };
  npmWorkspace = "packages/neovim";

  postInstall = ''
    mkdir -p $out/bin
    # Overwrite the unwanted wrapper created by buildNpmPackage
    ln -sf $out/lib/node_modules/neovim/bin/cli.js $out/bin/neovim-node-host
  '';

  meta = {
    mainProgram = "neovim-node-host";
    description = "Nvim msgpack API client and remote plugin provider";
    homepage = "https://github.com/neovim/node-client";
    changelog = "https://github.com/neovim/node-client/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fidgetingbits ];
  };
}
