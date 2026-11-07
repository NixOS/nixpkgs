{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.6.0-unstable-2026-11-04";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "e1e99e5868f1b61f9fc37e997b1ae981c8671033";
    hash = "sha256-pD3Y0Ry9gZhdrHAaSpHQrlNCpnQb7N+onS99pJu3jaA=";
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
