{
  fetchFromGitHub,
  gnupg,
  gpgme,
  installShellFiles,
  lib,
  libgit2,
  libgpg-error,
  lua5_4,
  makeWrapper,
  nix,
  openssl,
  perl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lux-cli";

  version = "0.18.7";

  src = fetchFromGitHub {
    owner = "lumen-oss";
    repo = "lux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nZslDD09PfETa0a3LuZGXlj7GETXTXK9vH8kpb40i9Y=";
  };

  buildAndTestSubdir = "lux-cli";

  cargoHash = "sha256-+j0Rs4aO+1BZ5fWN1we+MM9sJcXsupVF3LajhjJeoTA=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    perl
    pkg-config
  ];

  buildInputs = [
    gnupg
    gpgme
    libgit2
    libgpg-error
    lua5_4
    openssl
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
    LIBSSH2_SYS_USE_PKG_CONFIG = 1;
    LUX_SKIP_IMPURE_TESTS = 1; # Disable impure unit tests
  };

  cargoTestFlags = "--lib"; # Disable impure integration tests

  nativeCheckInputs = [
    lua5_4
    nix
  ];

  postBuild = ''
    cargo xtask dist-man
    cargo xtask dist-completions
  '';

  postInstall = ''
    installManPage target/dist/lx.1
    installShellCompletion target/dist/lx.{bash,fish} --zsh target/dist/_lx
  '';

  meta = {
    description = "Luxurious package manager for Lua";
    longDescription = ''
      A modern package manager for Lua.
      compatible with luarocks.org and the Rockspec specification,
      with first-class support for Nix and Neovim.
    '';
    homepage = "https://lux.lumen-labs.org/";
    changelog = "https://github.com/lumen-oss/lux/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
    mainProgram = "lx";
  };
})
