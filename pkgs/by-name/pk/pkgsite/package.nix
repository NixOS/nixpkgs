{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-03-12";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "9685cd9cccb49c53773c2b8ab8f2a5e6de3a1c12";
    hash = "sha256-aTvoi9HFYxDm7Ze+vJfQzMvgcdWUYOEyxrBpzqQdAK0=";
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
