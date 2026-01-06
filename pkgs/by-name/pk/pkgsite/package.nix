{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "3a74f05acd7522e74e16a35bdf80301dae44cfc9";
    hash = "sha256-1YTCjaPf6t0Tn/u1ERBxoHeXAIMO4wsPIcODBPJjrlM=";
  };

  vendorHash = "sha256-rruIjtXtFZ0MOJkWx4n+7apKGv4Pq6GrOWoQ3o+8KFs=";

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
