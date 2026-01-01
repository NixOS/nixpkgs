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

<<<<<<< HEAD
  version = "0.22.3";
=======
  version = "0.20.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lumen-oss";
    repo = "lux";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-YtDo6Njv8Cz8GWlSt1wKQjR9cUDPeru6F+V4g1lO640=";
=======
    hash = "sha256-L676xx3TL2HTJsnYVUcVAeFUt9s6U0KVTL2FHASlZno=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildAndTestSubdir = "lux-cli";

<<<<<<< HEAD
  cargoHash = "sha256-zggaQyzMJm0lI1qHa4Q5o9lMgSy29cp5HJMHqplpe6E=";
=======
  cargoHash = "sha256-dRQ8ICNOupY7GZdQGtHVd1OCXzgBHloptYgizW8Xf5M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
