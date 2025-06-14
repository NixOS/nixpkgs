{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-06-08";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "82c52f1754cd0ea741a56981d4830176071531d3";
    hash = "sha256-bI5jVmCM5pSdiT+OJGrg1pBQ6ozPbXdZzrdLxr9cMUU=";
  };

  vendorHash = "sha256-dZKm3dMI969HKPBrC95vVmY1cZmjy+NWq7xOzXsTE14=";

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
