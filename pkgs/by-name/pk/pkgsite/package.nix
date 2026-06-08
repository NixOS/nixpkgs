{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-05-29";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "b045357bb4e9728f75e705110c5ca0f7c7a78fbf";
    hash = "sha256-tdZHFoSoLUBB6I6FHRPG6rkPXB0dkgWC9RKqQHjP4YU=";
  };

  vendorHash = "sha256-jMHGQrGQjNsWNj7BnhRYDn17W+6VI3A940AkR4Rmvok=";

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
