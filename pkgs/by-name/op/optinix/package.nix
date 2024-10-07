{
  lib,
  fetchFromGitLab,
  buildGoModule,
  installShellFiles,
}:
buildGoModule rec {
  pname = "optinix";
  version = "0.1.3";

  src = fetchFromGitLab {
    owner = "hmajid2301";
    repo = "optinix";
    rev = "v${version}";
    hash = "sha256-Y+TCMKLLBcpGgbQbwt/F9PhcDoG9B156hHM9teD+vFA=";
  };

  vendorHash = "sha256-kwAmp3pP2oEETztJ28fW1H6cMp0mCBiunVy41I8aeEk=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd optinix \
      --bash <($out/bin/optinix completion bash) \
      --fish <($out/bin/optinix completion fish) \
      --zsh <($out/bin/optinix completion zsh)
  '';

  meta = {
    description = "Tool for searching options in Nix";
    homepage = "https://gitlab.com/hmajid2301/optinix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hmajid2301 ];
    mainProgram = "optinix";
  };
}
