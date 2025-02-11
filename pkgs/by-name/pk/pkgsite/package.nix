{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pkgsite";
  version = "0-unstable-2025-01-31";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "50d4697cc82f2eedc49fc659871d1e81ca4c6164";
    hash = "sha256-zDUsMkhQH/KJDjUE6mw/zRF23Ad3VIfqjEIY374Y9GE=";
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
