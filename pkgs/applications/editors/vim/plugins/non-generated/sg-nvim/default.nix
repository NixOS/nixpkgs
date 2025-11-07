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
  version = "1.1.0-unstable-2025-01-21";
  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "sg.nvim";
    rev = "775f22b75a9826eabf69b0094dd1d51d619fe552";
    hash = "sha256-i5g+pzxB8pAORLbr1wlYWUTsrJJmVj9UwlCg8pU3Suw=";
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
