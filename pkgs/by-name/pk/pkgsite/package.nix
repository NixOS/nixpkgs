{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-05-06";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "1bc9132f566501f5f66bfcb147479cf741704cf4";
    hash = "sha256-FfgwHiqbDhVp31YQzalveG+JVe93gXUq/XvTwPV7zsI=";
  };

  vendorHash = "sha256-s8uYvMQENqeUN8DbZ/jNhcTe2dJeiE9UYPCPGeScO10=";

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
