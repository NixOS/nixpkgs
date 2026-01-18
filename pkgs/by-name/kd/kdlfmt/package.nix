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
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "kdlfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IiR7luc474uL0B2lCGEl6taTM2VXRQCjo88TuWOh7ic=";
  };

  cargoHash = "sha256-ZlBsEPvATh9i3+davxTkJQeH2eeSJzoyweAhZhNkBgk=";

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
