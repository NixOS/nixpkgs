{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "sif";
  version = "0-unstable-2026-03-06";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "d6c52d3dd8ac6b3fb8401ae39d6d27a361e11c4f";
    hash = "sha256-Vj7XXt1QSFxx7dIHxchbM6bXa5TYxboAWSjtLRb3OvE=";
  };

  vendorHash = "sha256-D7yHDOLZuH6NWQyp8lwz3JBeRgLIN/jBSDBi9dltKf4=";

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
