{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "air-formatter";
  version = "0.12.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "air";
    tag = finalAttrs.version;
    hash = "sha256-w7A9fwH2d87KtvsfO4kmcTdsE2/UzFu8IybAeTHvYqM=";
  };

  cargoHash = "sha256-vHxBFmXZ5UEs0XPiXYhFcHvM0UFrwKtccTmXDVKEwM4=";

  useNextest = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  cargoBuildFlags = [ "--package=air" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ installShellFiles ];
  # TODO: Upstream also provides Elvish and PowerShell completions,
  # but `installShellCompletion` only has support for Bash, Zsh and Fish at the moment.
  postInstall = ''
    installShellCompletion --cmd air-formatter \
      --bash <($out/bin/air generate-shell-completion bash) \
      --fish <($out/bin/air generate-shell-completion fish) \
      --zsh  <($out/bin/air generate-shell-completion zsh)
  '';

  meta = {
    description = "Extremely fast R code formatter";
    homepage = "https://posit-dev.github.io/air";
    changelog = "https://github.com/posit-dev/air/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
    mainProgram = "air";
  };
})
