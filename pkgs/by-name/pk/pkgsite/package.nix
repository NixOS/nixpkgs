{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-08-14";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "ed9d06afb3a5d788c2bd4d6eef1b2a667cff4782";
    hash = "sha256-HROCrvfpHiRmZSE+P9uL5mwqkcI9uwxFEI7fSjzOHiI=";
  };

  vendorHash = "sha256-MUd0AGYDLx6o1uItjk3UVHBIXfPjN6AjjhYQCz5BIeQ=";

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
