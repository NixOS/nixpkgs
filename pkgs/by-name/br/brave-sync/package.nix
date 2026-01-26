{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "brave-sync";
  version = "0.1.21-unstable-2025-10-02";

  vendorHash = "sha256-zJaaLj/44oGFyIaX5V4F13zUOHRt4UawpPaglxdcYKI=";

  src = fetchFromGitHub {
    owner = "brave";
    repo = "go-sync";
    rev = "9aaf1352afe5250fe3565361f82e80b95f8a5792";
    hash = "sha256-NdPdjpN6EX9OLfyW0XXwUaKzj2N4K3J/ToI5Tja1MzY=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/brave/go-sync/server.version=${version}"
    "-X github.com/brave/go-sync/server.buildTime=0"
    "-X github.com/brave/go-sync/server.commit=${src.rev}"
  ];

  postInstall = ''
    mv $out/bin/go-sync $out/bin/brave-sync
  '';

  # Network tests hang (only in the nixbld environment) and there
  # are a few timeouts. Disabling for now.
  doCheck = false;

  meta = {
    description = "Sync server implemented in go to communicate with Brave sync clients";
    mainProgram = "brave-sync";
    homepage = "https://github.com/brave/go-sync";
    maintainers = with lib.maintainers; [
      moinakb001
    ];
    license = lib.licenses.mit;
  };
}
