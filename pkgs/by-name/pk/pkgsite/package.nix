{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.6.0-unstable-2026-10-24";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "8b2f2a882f6f534451aca170185b5aeb6e28f930";
    hash = "sha256-s8oiRvr36Y7ld0IcLckqIbyYSOloC9KzeR+tgmaL0ig=";
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
