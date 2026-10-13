{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.5.0-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "b0feb34c6d91fdea7d471ec6026383042ba8aa12";
    hash = "sha256-9ffml/zRIEajJDPsDtacP99j1/aHW8x9219y3UDgO9A=";
  };

  vendorHash = "sha256-7+Mg6iuebaKWv7QlX99dhs2WD4EYVYZIg+qvG5NBWSI=";

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
