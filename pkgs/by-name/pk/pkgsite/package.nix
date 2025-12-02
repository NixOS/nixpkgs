{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "84333735ffe124f7bd904805fd488b93841de49f";
    hash = "sha256-XYySnVvnNZr1tg46AoYBsmeT5y/StByWcQhnNOdoLJo=";
  };

  vendorHash = "sha256-Zv9kyBGLicSJlWD0/wv6ggteA+DttOb18/P5s91tJxE=";

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
