{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimPlugins,
  vimUtils,
}:
let
  version = "0-unstable-2024-10-27";
  src = fetchFromGitHub {
    owner = "nvim-pack";
    repo = "nvim-spectre";
    rev = "08be31c104df3b4b049607694ebb2b6ced4f928b";
    sha256 = "04v1gypga9fhmkddis5yyppvmpq0b1b7zpvbfjlxfp2z498l5n2v";
  };

  spectre_oxi = rustPlatform.buildRustPackage {
    pname = "spectre_oxi";
    inherit version src;
    sourceRoot = "${src.name}/spectre_oxi";

    cargoHash = "sha256-jVNeK1BeCzQaS5G561iWB3xEupzjIgnbUpEo1IVr9nQ=";

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
