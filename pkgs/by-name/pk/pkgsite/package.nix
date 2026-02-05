{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-01-16";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "550788255d99f0e9ee169f12bf65d16e1ede9f7b";
    hash = "sha256-Gx4MKLQ7Ed8XIy9oULWD1mRVcD2f7i+fb2aDjFrG9RI=";
  };

  vendorHash = "sha256-udLOOjBMLZ38jrX/7r+hmiUr/k6gxU0Sypo6S0ezep0=";

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
