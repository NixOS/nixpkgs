{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "gokrazy";
  version = "0-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "gokrazy";
    repo = "tools";
    rev = "27173734feb06fbff961fcd4a6157bcbbb3c43e8";
    hash = "sha256-Hdjig+v2PSTnn7Ise1MtYpJKsDyHQc5QMx+icurBWXc=";
  };

  vendorHash = "sha256-SMiKCc+IY+HE5fAfLZPTCbQwWKPFncR3DokKo1UKN/s=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/gok" ];

  nativeBuildInputs = [ installShellFiles ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

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
    maintainers = with lib.maintainers; [
      shayne
      slashformotion
    ];
    mainProgram = "gok";
  };
})
