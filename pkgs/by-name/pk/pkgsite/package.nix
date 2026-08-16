{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.3.0-unstable-2026-08-12";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "87ad201175e81c89d34ae301a43baa4f2768b732";
    hash = "sha256-jmbCalYhZaymxBBdO9uALl4SEbc48TC0GuJRwq35e4Y=";
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
