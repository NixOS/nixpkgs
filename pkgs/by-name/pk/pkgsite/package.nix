{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-09-11";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "133263251ca103a8ccecf603864f229dbdf71237";
    hash = "sha256-RQRJ5OH2Jljf3cWGHPgbZUipYc6LXCH6QUDsDJbxRAI=";
  };

  vendorHash = "sha256-HrHdtKsp/KcEg0l+ZmBb5gPaJldFiBFpjFBRnUnSEuM=";

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
