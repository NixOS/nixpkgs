{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.5.0-unstable-2026-09-21";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "7c00ecaad9879496c8e7878e937cc767975212dc";
    hash = "sha256-8Kw4+PKyjqKXHMgz1/dm8TS6V1h8Xsiuz4UX9jk5amg=";
  };

  vendorHash = "sha256-4ENzGavXCCcXkMu6jPv1Rqm3dZmtDD+a5Sr710I6zRA=";

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
