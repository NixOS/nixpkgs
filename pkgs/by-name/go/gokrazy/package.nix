{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "gokrazy";
  version = "0-unstable-2026-10-26";

  src = fetchFromGitHub {
    owner = "gokrazy";
    repo = "tools";
    rev = "942a8faaca93b86a8d52e8407d420553c4ec5783";
    hash = "sha256-EFSxhoSqG/aR++K34tbR1/ALV1eNZ5xocyZ57wmAISE=";
  };

  vendorHash = "sha256-5CpSzJEagGNnpMa3AHRku0rD5EprQj0jM24aBFECjjw=";

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
