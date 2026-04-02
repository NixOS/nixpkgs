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
  version = "0.5.1-nightly.538c593-unstable-2026-04-01";
  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    rev = "538c593b7ba173b08beec15e6bce66fccb8f6ab0";
    hash = "sha256-e+x1ELa2m60j2cQ9g99XSrAMMvmF3WtlMF5HWYrrJps=";
  };
  fff-nvim-lib = rustPlatform.buildRustPackage {
    pname = "fff-nvim-lib";
    inherit version src;

    cargoHash = "sha256-K6xAzx6YqzrDUalZ1rE4eOBRc1xvXVhac14krskl87M=";

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
