{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-11-13";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "28eed86815232e48f5e757569fcd061f858142d4";
    hash = "sha256-de6aDMNOE+N6OWwHD2p6jjuX2z0d6eKZeAYgatuJLgk=";
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
