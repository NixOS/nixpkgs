{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "gokrazy";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "gokrazy";
    repo = "tools";
    rev = "3fe400c13246e09469afca86df37cdc6fe7c3ee9";
    hash = "sha256-+wLO374SJu4Sk7GKwJkg6UOxWmJ1ApIfLt3Hw89/dXU=";
  };

  vendorHash = "sha256-+9i4dlxcxXw0WpeuHhnxli2qhB6IWOc4babuJXIO4wA=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/gok" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd gok \
      --bash <($out/bin/gok completion bash) \
      --fish <($out/bin/gok completion fish) \
      --zsh <($out/bin/gok completion zsh)
  '';

  meta = {
    description = "Turn your Go program(s) into an appliance running on the Raspberry Pi 3, Pi 4, Pi 5, Pi Zero 2 W, or amd64 PCs";
    homepage = "https://github.com/gokrazy/gokrazy";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ shayne ];
    mainProgram = "gok";
  };
})
