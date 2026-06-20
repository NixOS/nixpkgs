{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  openssl,
  perl,
  zig,
  gitMinimal,
  pkg-config,
  stdenv,
  vimUtils,
  writableTmpDirAsHomeHook,
}:
let
  version = "0.9.4";
  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    tag = "v${version}";
    hash = "sha256-q/RfjfVZMM8RyfOP1o2NjUP6NrOh7D2ribgq5Dvwxkc=";
  };
  fff-nvim-lib = rustPlatform.buildRustPackage {
    pname = "fff-nvim-lib";
    inherit version src;

    cargoHash = "sha256-NmQDTsevfJq6UGfoxaHwEX4+eJZLXebndpFAsbUNvl8=";

    cargoBuildFlags = [
      "-p"
      "fff-nvim"
      "--features"
      "zlob"
    ];

    cargoCheckFlags = [
      "-p"
      "fff-nvim"
      "--features"
      "zlob"
    ];

    nativeBuildInputs = [
      pkg-config
      perl
      rustPlatform.bindgenHook
      writableTmpDirAsHomeHook
      zig
    ];

    dontUseZigConfigure = true;
    dontUseZigBuild = true;
    dontUseZigCheck = true;
    dontUseZigInstall = true;

    # Some tests need git
    nativeCheckInputs = [ gitMinimal ];

    # Tests need these permissions in order to use the FSEvents API on macOS.
    sandboxProfile = ''
      (allow mach-lookup (global-name "com.apple.FSEvents"))
    '';

    buildInputs = [
      openssl
    ];

    checkFlags = [
      # This test requires curl and GitHub access
      "--skip=update_check::tests::test_update_check_end_to_end"

      # This test depends on catching a race window and is not deterministic
      "--skip=drop_during_post_scan_does_not_crash"
    ];

    env = {
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

  nvimSkipModules = [
    # Skip single file dev config for testing fff.nvim locally
    "empty_config"
  ];

  passthru = {
    updateScript = nix-update-script {
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
