{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "0e6de173c6b5ef31749de2ae384bb05ddc6726ba";
    hash = "sha256-WRNw+BjUY8/gj7tcPs0Ifz47JtBlU+SEIt12EZmtOjw=";
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
