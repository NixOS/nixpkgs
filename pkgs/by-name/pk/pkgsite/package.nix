{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pkgsite";
  version = "0-unstable-2025-01-21";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "ce52a304a0f4dccd8ae7abfdd3712c9dae7b4f34";
    hash = "sha256-6fZr9mi6SGIe7AUNv6cS6R+kBNjFbPfdamnpGclimWQ=";
  };

  vendorHash = "sha256-Z+Ji3RO2zn5vn9DXOAxyeI4OZXGOfyVdfdIsNyJHZpE=";

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
