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
  version = "1001eb8-unstable-2026-03-13";
  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    rev = "fcdf4a9172fba824ca6834731b93b74eba51d1c3";
    hash = "sha256-AYxWrqru0/HCrfTXRqTExiOT6mNzNMk+pT6APRs0BUM=";
  };
  fff-nvim-lib = rustPlatform.buildRustPackage {
    pname = "fff-nvim-lib";
    inherit version src;

    cargoHash = "sha256-nXtJPE6HNZx5Ra4CwYi/f4EWww//1XwsiwtRG77RPJk=";

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
      RUSTC_BOOTSTRAP = 1; # We need rust unstable features

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
