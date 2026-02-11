{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-02-06";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "2a8da3345a36148f4dca0cfb2b99cbe84ba9a50b";
    hash = "sha256-693eUnNtuagCwfXq+FYAVHHHgHDT0CDXu7kaYK2ru9Q=";
  };

  vendorHash = "sha256-udLOOjBMLZ38jrX/7r+hmiUr/k6gxU0Sypo6S0ezep0=";

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
