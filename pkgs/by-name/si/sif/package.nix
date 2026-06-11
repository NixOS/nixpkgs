{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "sif";
  version = "0-unstable-2026-06-11";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "d62919523abfecd06e07ba6528b15e9861bd747c";
    hash = "sha256-T/HIvcXG3OpSK7xhZpYnCWv4KsRn0bnLhyouPjgwUoE=";
  };

  vendorHash = "sha256-rOAubGbeDPl0LJovksKRfYJmUvU6hmx3Ht12M7eLiOA=";

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
