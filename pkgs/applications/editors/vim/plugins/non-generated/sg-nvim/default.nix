{
  lib,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  vimPlugins,
  vimUtils,
}:
let
  version = "1.1.0-unstable-2024-12-15";
  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "sg.nvim";
    rev = "7c423ebeb028b3534eb20fe54972825384dbe7d6";
    hash = "sha256-ALAYX/1MTk0fCA8THunoHz8QTlWkg+pgiSp2n3B4KrU=";
  };

  sg-nvim-rust = rustPlatform.buildRustPackage {
    pname = "sg-nvim-rust";
    inherit version src;

    cargoHash = "sha256-t0+0Zw8NjCD1VB1hTrSjOa1130IVanoTALdFoTloFe4=";

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [ openssl ];

    prePatch = ''
      rm .cargo/config.toml
    '';

    env.OPENSSL_NO_VENDOR = true;

    cargoBuildFlags = [ "--workspace" ];

    # tests are broken
    doCheck = false;
  };
in
vimUtils.buildVimPlugin {
  pname = "sg.nvim";
  inherit version src;

  checkInputs = with vimPlugins; [
    telescope-nvim
    nvim-cmp
  ];

  dependencies = [ vimPlugins.plenary-nvim ];

  postInstall = ''
    mkdir -p $out/target/debug
    ln -s ${sg-nvim-rust}/{bin,lib}/* $out/target/debug
  '';

  nvimSkipModule = [
    # Dependent on active fuzzy search state
    "sg.cody.fuzzy"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
      attrPath = "vimPlugins.sg-nvim.sg-nvim-rust";
    };

    # needed for the update script
    inherit sg-nvim-rust;
  };

  meta = {
    description = "Neovim plugin designed to emulate the behaviour of the Cursor AI IDE";
    homepage = "https://github.com/sourcegraph/sg.nvim/";
    license = lib.licenses.asl20;
  };
}
