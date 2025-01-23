{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimPlugins,
  vimUtils,
}:
let
  version = "0-unstable-2025-01-13";
  src = fetchFromGitHub {
    owner = "nvim-pack";
    repo = "nvim-spectre";
    rev = "ddd7383e856a7c939cb4f5143278fe041bbb8cb9";
    sha256 = "sha256-pZ7AH1U95IWMmhk/uBO0Lsxx78H5H9ygPxk/HIqFFlY=";
  };

  spectre_oxi = rustPlatform.buildRustPackage {
    pname = "spectre_oxi";
    inherit version src;
    sourceRoot = "${src.name}/spectre_oxi";

    cargoHash = "sha256-UieSVIITsk6iqd68JKFYYBTSDm4kPs+a9V+Y0gB9kFU=";

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
