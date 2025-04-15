{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-04-01";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "e806f9c8871f0247a0989e5124d82e7d841bce91";
    hash = "sha256-J8v0P+KIhh07c0G+XN5aWuVp2btaJel2T+U6g/D/2sM=";
  };

  vendorHash = "sha256-M4cbpMZ/ujnMUoGp//KpBM2oEl/RCOfI1IcmoGMw+fw=";

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
