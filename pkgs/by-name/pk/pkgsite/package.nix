{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-10-29";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "950d5ec0f5e9dbe92b2d1b1301322ea7f75ca1de";
    hash = "sha256-wclB22O0YEWwWA6zC7VByntmLeP9X5QLOb+hcFermko=";
  };

  vendorHash = "sha256-EbZ+38LLnp5aefiuBAOFHA3uPPUmPGLsDIEMln5Vh7c=";

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
