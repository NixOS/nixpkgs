{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-02-18";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "224a1368cf027909a3112d3267c37a34cec9ef38";
    hash = "sha256-04hGf60bhh7TLHjGLz2yRPsHI8bxGBkbSpJQLJsilt4=";
  };

  vendorHash = "sha256-Zb0rhIgdP5Ct8ypuEwRBrN2k+UZ6bZceI3B1XAMC0dk=";

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
