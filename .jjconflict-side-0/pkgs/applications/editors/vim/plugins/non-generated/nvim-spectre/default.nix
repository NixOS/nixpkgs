{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  vimPlugins,
  vimUtils,
}:
let
  version = "0-unstable-2025-04-24";
  src = fetchFromGitHub {
    owner = "nvim-pack";
    repo = "nvim-spectre";
    rev = "4497feffb18db4bab6e698bcb695228c19421282";
    hash = "sha256-pWSHOvV0VEouCyhrtn63k7+Lvs6reS81YJJCR3Ygnwg=";
  };

  spectre_oxi = rustPlatform.buildRustPackage {
    pname = "spectre_oxi";
    inherit version src;
    sourceRoot = "${src.name}/spectre_oxi";

    useFetchCargoVendor = true;
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
