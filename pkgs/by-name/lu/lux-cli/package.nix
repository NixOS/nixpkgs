{
  fetchFromGitHub,
  gnupg,
  gpgme,
  installShellFiles,
  lib,
  libgit2,
  libgpg-error,
  luajit,
  makeWrapper,
  nix,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "lux-cli";

  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "nvim-neorocks";
    repo = "lux";
    tag = "v0.7.3";
    hash = "sha256-d/WznA6BRduQJOFlE+ll1H7XtGXs9BPrhAKST09Lh0s=";
  };

  buildAndTestSubdir = "lux-cli";
  useFetchCargoVendor = true;
  cargoHash = "sha256-B1Fu5KWLL/XuUvIROPh0huLw4/OHe/c+LC0/gRFpBnc=";

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

  meta = {
    description = "Luxurious package manager for Lua";
    longDescription = ''
      A modern package manager for Lua.
      compatible with luarocks.org and the Rockspec specification,
      with first-class support for Nix and Neovim.
    '';
    homepage = "https://nvim-neorocks.github.io/";
    changelog = "https://github.com/nvim-neorocks/lux/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
    mainProgram = "lx";
  };
}
