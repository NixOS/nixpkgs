{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-05-22";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "866fa310855a76cf898838dac1cc56850e15cca6";
    hash = "sha256-zhBJ7sYXyzK9Rs2qA9CziIG50cCZ88a/msKzqIQIlJM=";
  };

  vendorHash = "sha256-A5gfYxgbq+5WG4W642fhRHw78oWGOrI+OyJ66W/gl00=";

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
