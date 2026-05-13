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
  version = "0.6.4";
  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff.nvim";
    tag = "v${version}";
    hash = "sha256-vu5yqOvVAPXHMi8sZFQuH9rNsFDffh3Ja74Be0Cs64c=";
  };
  fff-nvim-lib = rustPlatform.buildRustPackage {
    pname = "fff-nvim-lib";
    inherit version src;

    cargoHash = "sha256-w6KwiE0rAT00fiRa1rT8uthVgcMB7EFGoG3+M5MYEBo=";

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
    ];

    # Some tests need git
    nativeCheckInputs = [ gitMinimal ];

    # Tests need these permissions in order to use the FSEvents API on macOS.
    sandboxProfile = ''
      (allow mach-lookup (global-name "com.apple.FSEvents"))
    '';

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
