{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-04-02";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "2d0d60d0e456af02dfc52d79053d5a3a20fb11ff";
    hash = "sha256-mHTARhEwD7li9xJQdnjDesgZ4DE34N35oBJIqvo4aUY=";
  };

  vendorHash = "sha256-Dzizb692xTyCmaGpIoXU9OJ0//K+0QQ04vc4Dsnh34Q=";

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
