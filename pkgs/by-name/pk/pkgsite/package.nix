{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-10-09";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "31e4cbb15040258abb9a4e5eb0d5fcef6f8e0562";
    hash = "sha256-JCcutMJNeeqN7ruTwrvAIe44Xpi7Ne9UXVPnQW5ujEk=";
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
