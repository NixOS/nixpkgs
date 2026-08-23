{
  lib,
  stdenv,
  fetchFromGitLab,
  buildGoModule,
  installShellFiles,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "optinix";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "hmajid2301";
    repo = "optinix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cFzu88EFo27c6r7pqYDzMj9z1jPx4RxcylKYa4yxZXo=";
  };

  vendorHash = "sha256-b834KT/5P49hW6SqG6fPSiOanzQ1oAfpZ8wNkJP6pNs=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd optinix \
      --bash <($out/bin/optinix completion bash) \
      --fish <($out/bin/optinix completion fish) \
      --zsh <($out/bin/optinix completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for searching options in Nix";
    homepage = "https://gitlab.com/hmajid2301/optinix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hmajid2301
      brianmcgillion
    ];
    changelog = "https://gitlab.com/hmajid2301/optinix/-/releases/v${finalAttrs.version}";
    mainProgram = "optinix";
  };
})
