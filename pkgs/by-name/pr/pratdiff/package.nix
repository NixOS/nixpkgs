{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  testers,
  pratdiff,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pratdiff";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fowles";
    repo = "pratdiff";
    tag = finalAttrs.version;
    hash = "sha256-DuCCbozMXj/iboZyPoB8WQzEQREavBFkiVIBUH1GiLk=";
  };

  cargoHash = "sha256-sD6KwYLDD63YasVeyZ3tOBPm/GZz7zUOWJTyNmS4MH0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pratdiff \
      --bash <($out/bin/pratdiff --completions bash) \
      --fish <($out/bin/pratdiff --completions fish) \
      --zsh <($out/bin/pratdiff --completions zsh)
  '';

  passthru.tests.version = testers.testVersion { package = pratdiff; };

  meta = {
    description = "Colorful diff tool based on the patience diff algorithm";
    homepage = "https://github.com/fowles/pratdiff";
    changelog = "https://github.com/fowles/pratdiff/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.siriobalmelli ];
    mainProgram = "pratdiff";
  };
})
