{
  stdenv,
  buildPackages,
  fetchFromGitHub,
  gnupg,
  gpgme,
  installShellFiles,
  lib,
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

  version = "0.40.5";

  src = fetchFromGitHub {
    owner = "lumen-oss";
    repo = "lux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QBhXHj+8SnqouWxLi0MmoRnDfcznuh80lL1+ly8nGmI=";
  };

  buildAndTestSubdir = "lux-cli";

  cargoHash = "sha256-1R/rENLCUYn3d41cg6M2drdMjxrprI89i0wKA2j+QbY=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
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
    libgpg-error
    lua5_4
    openssl
  ];

  env = {
    LIBSSH2_SYS_USE_PKG_CONFIG = 1;
    LUX_SKIP_IMPURE_TESTS = 1; # Disable impure unit tests
  };

  cargoTestFlags = [
    "--lib" # Disable impure integration tests
  ];

  nativeCheckInputs = [
    lua5_4
    nix
  ];

  postInstall = ''
    ${
      # Using lx to generate man pages and completions is faster than xtask
      if stdenv.hostPlatform.emulatorAvailable buildPackages then
        let
          lx = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/lx";
        in
        ''
          ${lx} util man --target-dir="target/dist"
          ${lx} util completion --target-dir="target/dist"
        ''
      else
        ''
          cargo xtask dist-man
          cargo xtask dist-completions
        ''
    }
      installManPage target/dist/*.1
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
      ALameLlama
    ];
    platforms = lib.platforms.all;
    mainProgram = "lx";
  };
})
