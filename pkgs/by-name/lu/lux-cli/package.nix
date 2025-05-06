{
  gnupg,
  gpgme,
  installShellFiles,
  lib,
  libgit2,
  libgpg-error,
  lua51Packages,
  lua52Packages,
  lua53Packages,
  lua54Packages,
  luajit,
  makeWrapper,
  nix,
  openssl,
  pkg-config,
  rustPlatform,
  symlinkJoin,
  versionCheckHook,
}:
let
  lux-lua-bundle = symlinkJoin {
    name = "lux-lua-bundle";
    paths = [
      lua51Packages.lux-lua
      lua52Packages.lux-lua
      lua53Packages.lux-lua
      lua54Packages.lux-lua
    ];
  };
in
rustPlatform.buildRustPackage rec {
  pname = "lux-cli";

  version = "0.3.14";

  src = lua52Packages.lux-lua.src;

  buildAndTestSubdir = "lux-cli";
  useFetchCargoVendor = true;
  cargoHash = lua52Packages.lux-lua.cargoHash;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    gnupg
    gpgme
    libgit2
    libgpg-error
    luajit
    openssl
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
    LIBSSH2_SYS_USE_PKG_CONFIG = 1;
    LUX_SKIP_IMPURE_TESTS = 1; # Disable impure unit tests
  };

  cargoTestFlags = "--lib"; # Disable impure integration tests

  nativeCheckInputs = [
    luajit
    nix
  ];

  postBuild = ''
    cargo xtask dist-man
    cargo xtask dist-completions
  '';

  postFixup = ''
    # Instruct Lux to search for the lux-specific shared libraries in the lux-lua bundle
    # (temporary solution, until https://github.com/nvim-neorocks/lux/issues/655 is implemented)
    wrapProgram $out/bin/lx --set LUX_LIB_DIR "${lux-lua-bundle}"
  '';

  meta = {
    description = "Luxurious package manager for Lua";
    longDescription = ''
      A modern package manager for Lua.
      compatible with luarocks.org and the Rockspec specification,
      with first-class support for Nix and Neovim.
    '';
    homepage = "https://nvim-neorocks.github.io/";
    changelog = "https://github.com/nvim-neorocks/lux/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
    mainProgram = "lx";
  };
}
