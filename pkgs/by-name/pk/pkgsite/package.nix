{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "041c7c0b878cb88962867185208d4d2ec79de7d0";
    hash = "sha256-dyBOdUwod03c8eU1qfJecSDyKzol//yFpANCOihiseo=";
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
