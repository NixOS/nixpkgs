{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-05-08";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "2c817196d3698a5964356f8cd2da44048228b9dd";
    hash = "sha256-L5S97cp3EE/MLOzpO/Q3/B6zOtn1iRkZjfzEl3RDGNU=";
  };

  vendorHash = "sha256-BbCCOgx6Tis2e07nSftdIi7cv8cHIXlsZl5Qk4fsWh8=";

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
