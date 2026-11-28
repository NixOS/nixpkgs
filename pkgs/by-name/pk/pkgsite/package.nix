{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.6.0-unstable-2026-11-17";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "77f8e638b02c1a1b10b17141789f60f007402fa1";
    hash = "sha256-KDPyhZ/G/t45EpGdGYVeDQ55sLop4IFBKXYLimSTpvs=";
  };

  vendorHash = "sha256-szZUBy8Y4E22msGLshiDCQWJFfz9vn9oK1zb2QVUcjs=";

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
