{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lintspec";
  version = "0.18.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ORe9CjLB9dgq81jZ/Hbaem5H/NAZ4Rrv0uwll3bMRiE=";
  };

  cargoHash = "sha256-bQP4P6Ti57JfVwYV/qwiLh2KqnqfoualH5fAxG6g4Fk=";
  cargoBuildFlags = [
    "--package"
    "lintspec"
  ];

  strictDeps = true;
  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lintspec \
      --bash <($out/bin/lintspec completions -s bash) \
      --fish <($out/bin/lintspec completions -s fish) \
      --zsh <($out/bin/lintspec completions -s zsh)
  '';

  meta = {
    description = "Blazingly fast linter for NatSpec comments in Solidity code";
    homepage = "https://github.com/beeb/lintspec";
    changelog = "https://github.com/beeb/lintspec/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "lintspec";
  };
})
