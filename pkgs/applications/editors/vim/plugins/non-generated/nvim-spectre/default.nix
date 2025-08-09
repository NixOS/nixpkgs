{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimPlugins,
  vimUtils,
}:
let
  version = "0-unstable-2025-04-28";
  src = fetchFromGitHub {
    owner = "nvim-pack";
    repo = "nvim-spectre";
    rev = "197150cd3f30eeb1b3fd458339147533d91ac385";
    hash = "sha256-ATW1QJ2aXHcUtGK6MNLSq4VkML3FLQphVcLqfzoX9PI=";
  };

  spectre_oxi = rustPlatform.buildRustPackage {
    pname = "spectre_oxi";
    inherit version src;
    sourceRoot = "${src.name}/spectre_oxi";

    cargoHash = "sha256-0szVL45QRo3AuBMf+WQ0QF0CS1B9HWPxfF6l6TJtv6Q=";

    preCheck = ''
      mkdir tests/tmp/
    '';

    checkFlags = [
      # Flaky test (https://github.com/nvim-pack/nvim-spectre/issues/244)
      "--skip=tests::test_replace_simple"
    ];
  };
in
vimUtils.buildVimPlugin {
  pname = "nvim-spectre";
  inherit version src;

  dependencies = [ vimPlugins.plenary-nvim ];

  postInstall = ''
    ln -s ${spectre_oxi}/lib/libspectre_oxi.* $out/lua/spectre_oxi.so
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
      attrPath = "vimPlugins.nvim-spectre.spectre_oxi";
    };

    # needed for the update script
    inherit spectre_oxi;
  };

  meta = {
    homepage = "https://github.com/nvim-pack/nvim-spectre/";
    license = lib.licenses.mit;
  };
}
