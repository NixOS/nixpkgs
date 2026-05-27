{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "sif";
  version = "0-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "bf802a7c0b83e7ba41b837fe9e1e3265e52d11f1";
    hash = "sha256-wkK3VCvpS2ETbAvgb5onsluLy1pXj0u8kpFy9AtvaBk=";
  };

  vendorHash = "sha256-1U8LV5ZVQkMZUK282FE42RRXdWz7HcpzOK03mA0f0r0=";

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
