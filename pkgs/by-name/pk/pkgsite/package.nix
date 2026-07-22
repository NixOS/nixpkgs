{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.2.0-unstable-2026-06-24";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "60f10bf3d57b68dccf4e1dfd573a72ec8db114d5";
    hash = "sha256-9jS1eXl1Mg/YwCVSZmpePHcwRKuiGXYOiDmNALRLmyY=";
  };

  vendorHash = "sha256-pamVUaMpkNVGY9tWPHsIiqflthzwELFOxgn90ncor/U=";

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
