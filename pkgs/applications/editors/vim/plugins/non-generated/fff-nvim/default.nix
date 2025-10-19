{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
  openssl,
  vimUtils,
  nix-update-script,
}:
let
  version = "0-unstable-2025-10-18";
  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    rev = "ee8bd6e839ff3e70660e794d79d4ce26a33a8e1e";
    hash = "sha256-Wj6YLTUqLzOngiSDkM3ci85WwdQgjoonwHbvXyvN9cE=";
  };
  fff-nvim-lib = rustPlatform.buildRustPackage {
    pname = "fff-nvim-lib";
    inherit version src;

    postPatch = ''
      substituteInPlace $cargoDepsCopy/neo_frizbee*/src/lib.rs \
        --replace-fail "#![feature(avx512_target_feature)]" ""
    '';

    cargoHash = "sha256-ZZt4BlMgRik4LH92F5cgS84WI1Jeuw68jP+y1+QXfDE=";

    nativeBuildInputs = [
      pkg-config
      perl
    ];

    buildInputs = [
      openssl
    ];

    env = {
      RUSTC_BOOTSTRAP = 1; # We need rust unstable features

      OPENSSL_NO_VENDOR = true;
    };
  };
in
vimUtils.buildVimPlugin {
  pname = "fff.nvim";
  inherit version src;

  postPatch = ''
    substituteInPlace lua/fff/download.lua \
      --replace-fail \
        "return plugin_dir .. '/../target'" \
        "return '${fff-nvim-lib}/lib'"
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
      attrPath = "vimPlugins.fff-nvim.fff-nvim-lib";
    };

    # needed for the update script
    inherit fff-nvim-lib;
  };

  meta = {
    description = "Fast Fuzzy File Finder for Neovim";
    homepage = "https://github.com/dmtrKovalenko/fff.nvim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
  };
}
