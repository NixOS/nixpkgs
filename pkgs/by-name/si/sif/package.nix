{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "sif";
  version = "0-unstable-2026-06-09";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "83ac92a4b82a0ab92257c580c9b6a3b82ab66af9";
    hash = "sha256-VeURSRwvuh+VJd94mG2F8wQWD6NIitxqwRQr3IJ0QzU=";
  };

  vendorHash = "sha256-fR63/dStMsZon22vancuLWIAvZiEYMLjMwY1kmRDNgM=";

  subPackages = [ "cmd/sif" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  # network-dependent tests
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0-unstable-.*)"
    ];
  };

  meta = {
    description = "Modular pentesting toolkit written in Go";
    homepage = "https://github.com/vmfunc/sif";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vmfunc ];
    mainProgram = "sif";
  };
}
