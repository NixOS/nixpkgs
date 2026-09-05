{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  vimPlugins,
  vimUtils,
  stdenv,
  nix-update-script,
}:
let
  version = "0.6.0-unstable-2026-09-04";

  src = fetchFromGitHub {
    owner = "Saghen";
    repo = "blink.pairs";
    rev = "21c2ac9164b36ae5e22f84a2dd0f02eaf107f8fe";
    hash = "sha256-z+1CnzU/YGLTES2b/B+ELPAZ4+aeChJpgEA3Use94q0=";
  };

  blink-pairs-lib = rustPlatform.buildRustPackage {
    pname = "blink-pairs";
    inherit version src;

    cargoHash = "sha256-XLlluprxhVueHhkIufJa7fJXvFxpJJzh89+yL9PZ4GI=";

    env = {
      RUSTC_BOOTSTRAP = 1;

      # Allow undefined symbols on Darwin - they will be provided by Neovim's LuaJIT runtime
      RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";
    };

    # NOTE: Disabled upstream too
    doCheck = false;

    nativeBuildInputs = [
      pkg-config
    ];
  };
in
vimUtils.buildVimPlugin {
  pname = "blink.pairs";
  inherit version src;

  dependencies = [ vimPlugins.blink-lib ];

  preInstall =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p lib
      ln -s ${blink-pairs-lib}/lib/libblink_pairs_parser${ext} lib/
    '';

  nvimSkipModules = [
    # a module to quickly setup a minimal reproduction environment for testing
    # bugs. therefore mostly useless from a consumer side
    "repro"
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.blink-pairs.blink-pairs-lib";
    };

    # needed for the update script
    inherit blink-pairs-lib;
  };

  meta = {
    description = "Rainbow highlighting and intelligent auto-pairs for Neovim";
    homepage = "https://github.com/Saghen/blink.pairs";
    changelog = "https://github.com/Saghen/blink.pairs/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      isabelroses
      saadndm
    ];
  };
}
