{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-02-12";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "ce44214c045bc223217f4e969a2b2d3f249b7c21";
    hash = "sha256-8GPeedY0CKjJ/HJmRZj91FIVuMPNmEKamWnKV6hFrk8=";
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
