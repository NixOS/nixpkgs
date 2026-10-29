{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "gokrazy";
  version = "0-unstable-2026-10-20";

  src = fetchFromGitHub {
    owner = "gokrazy";
    repo = "tools";
    rev = "8e26fb9532e18e2f9c4ee86bcfdee993e7c0d3e2";
    hash = "sha256-Ry5pTi1rs2b1vfQwExZ5wv2pKC7egVlPRGIc7q/8+w8=";
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
