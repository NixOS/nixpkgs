{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "sttr";
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "abhimanyu003";
    repo = "sttr";
    rev = "v${version}";
    hash = "sha256-8xIVLUbqk7bPjDTO2tdU9dGslBEorQusaJSAuFhRZYw=";
  };

  vendorHash = "sha256-OuPPK4ordP/yzH+0sCRKO9szJ81LUbvM2Z8U88O6Qwc=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd sttr \
      --bash <($out/bin/sttr completion bash) \
      --fish <($out/bin/sttr completion fish) \
      --zsh <($out/bin/sttr completion zsh)
  '';

  meta = with lib; {
    description = "Cross-platform cli tool to perform various operations on string";
    homepage = "https://github.com/abhimanyu003/sttr";
    changelog = "https://github.com/abhimanyu003/sttr/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Ligthiago ];
    mainProgram = "sttr";
  };
}
