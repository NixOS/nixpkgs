{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "6c973a1b2cc4702635ceccabe0c4b9e87d564a24";
    hash = "sha256-OquWb+1a5Bo1T6q9URiTXMvvZagkhL5dCelPlcyRbjw=";
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
