{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-09-08";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "f655b297736ff88a3f37c952fb49266ab92fa130";
    hash = "sha256-R+LXpmTw/sP5Vb4IaTt7x1vxpPePW8/3Broz3J1d1So=";
  };

  vendorHash = "sha256-MUd0AGYDLx6o1uItjk3UVHBIXfPjN6AjjhYQCz5BIeQ=";

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
