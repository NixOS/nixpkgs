{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-05-14";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "a5fcada8aa006fec3698037f4702e66122994e6c";
    hash = "sha256-kY3uXHsXDYRml4mZAZaFK95BDju92cmMZ4XoSNoNquo=";
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
