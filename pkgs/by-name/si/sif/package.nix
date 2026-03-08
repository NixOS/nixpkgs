{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "sif";
  version = "0-unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "237dfde4d1c10339efb62cc5e5ade18c0050f70c";
    hash = "sha256-XRK4qZWAU+7JO07Kuo9hF7cGWJ+ljjnG4SHQ05nS91M=";
  };

  vendorHash = "sha256-npwwYuAEMKm61T+s604kblrcHKBWMnMs4OHfOOqREkA=";

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
