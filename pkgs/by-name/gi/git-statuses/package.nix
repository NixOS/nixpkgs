{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  openssl,
  git,
  versionCheckHook,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-statuses";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "bircni";
    repo = "git-statuses";
    tag = finalAttrs.version;
    hash = "sha256-phGEp9wo46owe47H+XjfDD5OlcN8cGr1oaeYMpkWies=";
  };

  cargoHash = "sha256-yG5oSwnhoFVbwdTteRgW1ljVmTnxoh8l4gG/pGuRmic=";

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    openssl
  ];
  nativeInstallCheckInputs = [
    git
    versionCheckHook
  ];
  doInstallCheck = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-statuses \
      --bash <($out/bin/git-statuses --completions bash) \
      --fish <($out/bin/git-statuses --completions fish) \
      --zsh <($out/bin/git-statuses --completions zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool to display the status of multiple Git repositories in a clear, tabular format";
    homepage = "https://github.com/bircni/git-statuses";
    changelog = "https://github.com/bircni/git-statuses/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "git-statuses";
  };
})
