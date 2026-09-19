{
  lib,
  buildNpmPackage,
  fetchNpmDeps,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "node-client";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "node-client";
    tag = "v${version}";
    hash = "sha256-bhO52di2NmXk2VI8eFwxVKkPh1yEGJCeWXp3xLBWFFQ=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-Vl6VPcwDrYAC4HWeY+6eWPl/2+Mw6fkScS5fsrLlWxw=";
  };

  buildPhase = ''
    runHook preBuild
    npm run build
    runHook postBuild
  '';

  postInstall = ''
    mkdir $out/bin
    ln -s $out/lib/node_modules/neovim/node_modules/.bin/neovim-node-host $out/bin/neovim-node-host
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/neovim-node-host";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Nvim msgpack API client and remote plugin provider";
    homepage = "https://github.com/neovim/node-client";
    changelog = "https://github.com/neovim/node-client/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fidgetingbits ];
    mainProgram = "neovim-node-host";
  };
}
