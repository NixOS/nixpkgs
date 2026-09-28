{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lintspec";
  version = "0.19.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "lintspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V5HwQeopWKrq0X8mo33hPEAX/HiQ1t8/gdLzS3fzlD0=";
  };

  cargoHash = "sha256-JgU2xsZxO/oCJBE+kv6/bSBSu+ivXd0XbAuMd4KpeYc=";
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
