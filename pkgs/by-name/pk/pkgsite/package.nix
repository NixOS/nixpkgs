{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-02-25";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "d29b966ca794634ccd1758dcd59cd2c8baf23422";
    hash = "sha256-oNCkjcBC2dCJloJUcPpFqhGDQQMSzalZKITKt8IyL4Q=";
  };

  vendorHash = "sha256-G/XTWobysyzONctabYDIfAQ/zaAA9w2Ky7Hn6cj9l/c=";

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
