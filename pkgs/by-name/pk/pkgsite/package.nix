{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.3.0-unstable-2026-07-16";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "8d05c43dae2e668886572ee959babdb429ad6429";
    hash = "sha256-xc/pPJIRGuTGrdh2VFwPY+uud98ST0HaFPUsa5GvvhQ=";
  };

  vendorHash = "sha256-NZzA9QxVSYuSjeZOiwUAXAPBrN00JLHQNPp1lXqtmCw=";

  subPackages = [ "cmd/pkgsite" ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Official tool to extract and generate documentation for Go projects like pkg.go.dev";
    homepage = "https://github.com/golang/pkgsite";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "pkgsite";
  };
}
