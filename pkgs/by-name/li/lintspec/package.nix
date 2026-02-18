{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lintspec";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-giCPigyLkWv2d8hdXT3ZmYjl7mYRlTxua0N0JpeC/kc=";
  };

  cargoHash = "sha256-XsGkEy/uNmd2Em+ypDAAVKDeioaGafzFFHVL18Z0pdg=";
  cargoBuildFlags = [
    "--package"
    "lintspec"
  ];

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
