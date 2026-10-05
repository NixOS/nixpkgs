{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "gokrazy";
  version = "0-unstable-2026-09-13";

  src = fetchFromGitHub {
    owner = "gokrazy";
    repo = "tools";
    rev = "64f7f697dfff1a24457b00cd93ca5c30c866f34e";
    hash = "sha256-puqXa3OpHyzPpOYuf/SicoMJTNDf0hovLE/TOhmBDSw=";
  };

  vendorHash = "sha256-+9i4dlxcxXw0WpeuHhnxli2qhB6IWOc4babuJXIO4wA=";

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
