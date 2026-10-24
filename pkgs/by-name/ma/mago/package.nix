{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mago";
  version = "1.57.0";

  src = fetchFromGitHub {
    owner = "carthage-software";
    repo = "mago";
    tag = finalAttrs.version;
    hash = "sha256-UCBM3c3/c0JrooHoHoQ4ZmA9Gpiaj/aPbph/gE77KHI=";
    forceFetchGit = true; # Does not download all files otherwise
  };

  cargoHash = "sha256-/MWFZjjyvNbtbxaOj6eKfOQpdfdS+0Ywb7gEM9KXNY8=";

  env = {
    # Get openssl-sys to use pkg-config
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mago \
      --bash <("$out/bin/mago" generate-completions bash) \
      --zsh <("$out/bin/mago" generate-completions zsh) \
      --fish <("$out/bin/mago" generate-completions fish)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/carthage-software/mago/releases/tag/${finalAttrs.version}";
    description = "Toolchain for PHP that aims to provide a set of tools to help developers write better code";
    homepage = "https://github.com/carthage-software/mago";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      atomicptr
      hythera
      patka
    ];
    mainProgram = "mago";
  };
})
