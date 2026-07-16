{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kdlfmt";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "kdlfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ftzf4gI7E5tPo8U5ZxUMqlY5+AK5IEUUAll+GsEKYpg=";
  };

  cargoHash = "sha256-B/ir+Sf4uxQ9Fqmy6yEa3DMt0qdpfPrwD8lhUMOEUbo=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kdlfmt \
      --bash <($out/bin/kdlfmt completions bash) \
      --fish <($out/bin/kdlfmt completions fish) \
      --zsh <($out/bin/kdlfmt completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Formatter for kdl documents";
    homepage = "https://github.com/hougesen/kdlfmt";
    changelog = "https://github.com/hougesen/kdlfmt/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      airrnot
      defelo
    ];
    mainProgram = "kdlfmt";
  };
})
