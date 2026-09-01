{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.4.0-unstable-2026-08-28";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "91697af73a32a808f0bd7b732bdba661fda595c7";
    hash = "sha256-d7ueXE32f+cBw56+rp7DG9TpH/hNvW7ND3XPNY5sJhk=";
  };

  vendorHash = "sha256-HSEroer2bQbXWFBW9whOOebTvxW+QuzcPCd9XOya5r4=";

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
