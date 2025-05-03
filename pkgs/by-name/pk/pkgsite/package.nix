{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "e863a039941fdd1a92fb694c3d9b3bb0ea0ba257";
    hash = "sha256-wb451BDpKT404oMmyOXuZBGM7rWLiWJHTRTtphOgx9g=";
  };

  vendorHash = "sha256-JoPuNktN4OsdNJ0e8BRuuD0CKuWiFsAcLAS5h9rH/Z0=";

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
