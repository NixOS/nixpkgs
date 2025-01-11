{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pkgsite";
  version = "0-unstable-2025-01-08";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "840de57bb85975c3c0bcb24ba00fee86ef8c0748";
    hash = "sha256-TNnZG9Q3RmB5TfHDqPCHfChsdkZ6FOErbzo47cRXhTw=";
  };

  vendorHash = "sha256-Z+Ji3RO2zn5vn9DXOAxyeI4OZXGOfyVdfdIsNyJHZpE=";

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
