{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "ghtkn";
  version = "0.4.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "ghtkn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EtILxa6d6kmsd/6DykGqfokc3rrsXzf7ciettCkgo5E=";
  };

  vendorHash = "sha256-oA9US4CoGZrkhyVCiDooV5PkTV9akDUtcSqguc+4sEk=";

  ldflags = [ "-X=main.version=${finalAttrs.version}" ];

  subPackages = [ "cmd/ghtkn" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ghtkn \
      --bash <($out/bin/ghtkn completion bash) \
      --fish <($out/bin/ghtkn completion fish) \
      --zsh <($out/bin/ghtkn completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script {
    # Ignore pre-release versions ending in a "-<digit>" suffix, ex "v0.3.4-0"
    extraArgs = [
      "--version-regex"
      "^v(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Create short-lived GitHub App User Access Tokens for secure local development";
    longDescription = ''
      ghtkn issues short-lived GitHub App User Access Tokens via the OAuth
      device flow and caches them in a backend (OS keyring, the ghtkn agent,
      or a plain text file). Use it to authenticate the gh CLI, Git, and other
      tools without long-lived Personal Access Tokens.
    '';
    homepage = "https://github.com/suzuki-shunsuke/ghtkn";
    changelog = "https://github.com/suzuki-shunsuke/ghtkn/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aidandenlinger ];
    mainProgram = "ghtkn";
  };
})
