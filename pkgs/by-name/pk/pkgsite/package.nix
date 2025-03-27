{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-03-21";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "d037ac96d503b32fcdcb5f5efeefef10447c394e";
    hash = "sha256-/zcnS3qYmiI5kuOZ4jJB7/3C2U9KELYgte7d9OgaLmo=";
  };

  vendorHash = "sha256-M4cbpMZ/ujnMUoGp//KpBM2oEl/RCOfI1IcmoGMw+fw=";

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
