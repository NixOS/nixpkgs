{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  openssl,
  perl,
  pkg-config,
  stdenv,
  vimUtils,
}:
let
  version = "896355b-unstable-2026-02-07";
  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    rev = "d7bc72786d4362ca70aa05d397f8d08bbaf39604";
    hash = "sha256-CqX2QoDO7InjXYMzvljufA0QYhvFbsht2auE0+nVktw=";
  };
  fff-nvim-lib = rustPlatform.buildRustPackage {
    pname = "fff-nvim-lib";
    inherit version src;

    cargoHash = "sha256-jch2snZVoDqPkbeuF++yc/3ikoWal29bTKZjkyDgVjU=";

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

      # Allow undefined symbols on Darwin - they will be provided by Neovim's LuaJIT runtime
      RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";
    };
  };
in
vimUtils.buildVimPlugin {
  pname = "fff.nvim";
  inherit version src;

  postPatch = ''
    substituteInPlace lua/fff/download.lua \
      --replace-fail \
        "return plugin_dir .. '/../target/release'" \
        "return '${fff-nvim-lib}/lib'"
  '';

  nvimSkipModule = [
    # Skip single file dev config for testing fff.nvim locally
    "empty_config"
  ];

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
      saadndm
    ];
  };
}
