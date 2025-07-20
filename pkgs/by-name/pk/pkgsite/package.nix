{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "d4de6668b91034bd7c6315aff98f232c1339335f";
    hash = "sha256-H3yL82obJ/z8BDeyLdR1DVCxsPwrn0xxHLoMFHKhQn8=";
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
