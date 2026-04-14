{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-04-10";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "70e5087371296e2632232f4a3a795f124c73baf3";
    hash = "sha256-URPLE5ZHXpMuB3yLObMCOD5PR14KAbOBsc+aGQKubaA=";
  };

  vendorHash = "sha256-BbCCOgx6Tis2e07nSftdIi7cv8cHIXlsZl5Qk4fsWh8=";

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
