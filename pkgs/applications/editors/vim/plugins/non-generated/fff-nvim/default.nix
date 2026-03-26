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
  version = "0.4.3-nightly.0a18692-unstable-2026-03-24";
  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    rev = "eb577ea4f39f7b9296ff8c6b4bf2b2899d017ded";
    hash = "sha256-m/KykUyhE3xUVmmE84xUaqW0T4fbuRp6iAVBbCioiCI=";
  };
  fff-nvim-lib = rustPlatform.buildRustPackage {
    pname = "fff-nvim-lib";
    inherit version src;

    cargoHash = "sha256-hMwPyPc4V0pTxpn1U3ay31KttFeoU54h6Z4HGv8nFYQ=";

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
