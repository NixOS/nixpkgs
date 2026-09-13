{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "rapg";
  version = "0.3.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kanywst";
    repo = "rapg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-177xGyl63fJUntrBIfo04OS06oLosbzrX6p6bVZI3hw=";
  };

  vendorHash = "sha256-Q3o2q3T9rDrmepw9eS4wlrfhj61Aau/VQ8KpX8xOc14=";

  subPackages = [ "cmd/rapg" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/kanywst/rapg/internal/version.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rapg \
      --bash <($out/bin/rapg completion bash) \
      --fish <($out/bin/rapg completion fish) \
      --zsh <($out/bin/rapg completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first secret manager that injects secrets into child processes";
    longDescription = ''
      rapg keeps development secrets in an encrypted local vault (Argon2id and
      AES-256-GCM over SQLite) and injects them into a child process as
      environment variables instead of writing a .env file. Secrets are scoped
      per project through a .rapg.toml namespace, isolated from other projects
      by default. It can also mask vault values in text before it is shared.
    '';
    homepage = "https://github.com/kanywst/rapg";
    changelog = "https://github.com/kanywst/rapg/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kanywst ];
    mainProgram = "rapg";
  };
})
