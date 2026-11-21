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
  version = "1.1.0-unstable-2026-11-11";
  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "sg.nvim";
    rev = "ee5b5aaec0444ba2de057654b706208fca93f40e";
    hash = "sha256-WrPrFBeM2e5akE6aOh/MVfYdBcVgfDPkRTDdOFmy9c4=";
  };

  sg-nvim-rust = rustPlatform.buildRustPackage {
    pname = "sg-nvim-rust";
    inherit version src;

    cargoHash = "sha256-yY/5w2ztmTKJAYDxBJND8itCOwRNi1negiFq3PyFaSM=";

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

  nvimSkipModules = [
    # Dependent on active fuzzy search state
    "sg.cody.fuzzy"
    # Invokes a request that fails in the check hook
    # https://github.com/sourcegraph/sg.nvim/blob/ee5b5aaec0444ba2de057654b706208fca93f40e/lua/sg/health.lua#L2
    "sg.health"
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
