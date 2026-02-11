{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "sif";
  version = "0-unstable-2026-01-11";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    tag = "automated-release-c988e54";
    hash = "sha256-/9LRmSrji/8SCD9aHx82HwBfBRPVKzOnogw+uvDI+WI=";
  };

  vendorHash = "sha256-ztKXnOjZS/jMxsRjtF0rIZ3lKv4YjMdZd6oQFRuAtR4=";

  subPackages = [ "cmd/sif" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  # network-dependent tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modular pentesting toolkit written in Go";
    homepage = "https://github.com/vmfunc/sif";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vmfunc ];
    mainProgram = "sif";
  };
}
