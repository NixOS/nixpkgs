{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-10-24";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "4bd6c634f204f1469ab5130fc5b65eb843e98aac";
    hash = "sha256-zKgx7nQgmQyyHEobTlu92FMGPn3DABAA9KwkBaIjRsQ=";
  };

  vendorHash = "sha256-EbZ+38LLnp5aefiuBAOFHA3uPPUmPGLsDIEMln5Vh7c=";

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
