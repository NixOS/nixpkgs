{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-07-14";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "01b046e81fe76030480fef8109ae0f3627dabcc0";
    hash = "sha256-3hqLi50WJlDgRPdZ/WBydRxb+HLRnT7R79e9vOiqUgg=";
  };

  vendorHash = "sha256-sHpWI3oUuazFlWJhHB5uZ89z1GPbPfLoFQL12Jk3NP0=";

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
