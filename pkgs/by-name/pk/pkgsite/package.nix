{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-07-04";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "eac0bf970406fce3244072d54d7843a6697b91be";
    hash = "sha256-0JwcLEqVoWn8EWqzwOzULqkVaSTwmukpZ+YlwgKDd+0=";
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
