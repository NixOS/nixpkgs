{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.3.0-unstable-2026-07-24";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "95d18f84b8d26222de17dcd0ed885623fab0e8a3";
    hash = "sha256-mYZsdMCiY/vJRUXUZA2r0Uqg0uK0P1ZE62Vm+ibnMsQ=";
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
