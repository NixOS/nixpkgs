{
  lib,
  buildNpmPackage,
  fetchNpmDeps,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "node-client";
  version = "5.1.1-dev.0";
  src = fetchFromGitHub {
    owner = "neovim";
    repo = "node-client";
    rev = "d99ececf115ddc8ade98467417c1bf0120b676b5";
    hash = "sha256-eiKyhJNz7kH2iX55lkn7NZYTj6yaSZLMZxqiqPxDIPs=";
  };
  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-UoMq+7evskxtZygycxLBgeUtwrET8jYKeZwMiXdBMAw=";
  };
  npmWorkspace = "packages/neovim";

  postInstall = ''
    mkdir -p $out/bin
    # Overwrite the unwanted wrapper created by buildNpmPackage
    ln -sf $out/lib/node_modules/neovim/bin/cli.js $out/bin/neovim-node-host
  '';

  meta = {
    mainProgram = "node-client";
    description = "Nvim msgpack API client and remote plugin provider";
    homepage = "https://github.com/neovim/node-client";
    changelog = "https://github.com/neovim/node-client/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fidgetingbits ];
  };
}
