{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-11-28";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "d74adeade195e94064b1dc38fd14b93037ad7694";
    hash = "sha256-Rlm5XwOLjGYOtg12tlUtkd2+upY2EP7x5dI+Nx2JAF0=";
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
