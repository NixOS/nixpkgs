{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.6.0-unstable-2026-10-13";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "690d333e629a923827adb90aa14aa03dc797e471";
    hash = "sha256-RzHM+kDjRFiGdJHCc688oJmBvzSaYPhFgr4e45aULlU=";
  };

  vendorHash = "sha256-LaszOZapnJGKCYSZZWal10ZT53ahge6tABn6QgYnozs=";

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
