{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-03-26";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "95295059bea6702b583a9530f8335fa353fbf601";
    hash = "sha256-OF6dWNs23PsRgwke7ydElTPrsBXRBwI3zMuBvCaWIk4=";
  };

  vendorHash = "sha256-Dzizb692xTyCmaGpIoXU9OJ0//K+0QQ04vc4Dsnh34Q=";

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
