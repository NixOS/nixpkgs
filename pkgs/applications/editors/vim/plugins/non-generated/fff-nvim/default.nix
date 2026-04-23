{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  openssl,
  perl,
  zig,
  pkg-config,
  stdenv,
  vimUtils,
}:
let
  version = "0.4.3-nightly.dd56a3a-unstable-2026-03-20";
  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    rev = "dd56a3a8a8a5a85522badaf6485f28c8f7a7c840";
    hash = "sha256-F9fnjCwBEJfuK0TuRr7XjMcacMep5K0SuzGft2IFXtQ=";
  };
  fff-nvim-lib = rustPlatform.buildRustPackage {
    pname = "fff-nvim-lib";
    inherit version src;

    cargoHash = "sha256-Xhn+EpVF7XQOgHQpmoHHrZ/swi2xgdEFYh8D6mYJMSc=";

    nativeBuildInputs = [
      pkg-config
      perl
      rustPlatform.bindgenHook
    ];

    buildInputs = [
      openssl
    ];

    # This test requires curl and GitHub access
    checkFlags = [
      "--skip=update_check::tests::test_update_check_end_to_end"
    ];

    env = {
      OPENSSL_NO_VENDOR = true;

      # Allow undefined symbols on Darwin - they will be provided by Neovim's LuaJIT runtime
      RUSTFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-C link-arg=-undefined -C link-arg=dynamic_lookup";

      ZIG = lib.getExe zig; # zlob requires zig
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
