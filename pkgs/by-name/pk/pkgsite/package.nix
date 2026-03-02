{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "bf658f25df2c830b76166ce77350f62e90834365";
    hash = "sha256-9sGomOK0GCeUHDjo6HwKHLXR6DC/V1I7ev6Co/7FpXc=";
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
