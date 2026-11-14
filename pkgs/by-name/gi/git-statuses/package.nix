{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  libgit2,
  openssl,
  git,
  versionCheckHook,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-statuses";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bircni";
    repo = "git-statuses";
    tag = finalAttrs.version;
    hash = "sha256-2TY5/3+NLCews07fQ5nrmubmICmdKhqFFvvI0VvFlRI=";
  };

  cargoHash = "sha256-LWeQYsH6xG9RCCp8BROmrK2jP5XcXnyGZPy7rVnvr94=";

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    libgit2
    openssl
  ];

  # tests print tables and check their content,
  # but in the sandbox, stty has "rows 0; columns 0;"
  # so a newline is inserted after every char
  preCheck = ''
    stty -F /dev/stdout cols 100
  '';

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
