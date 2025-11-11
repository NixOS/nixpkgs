{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-11-06";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "0d7e29046a911358f7f5a5c4028a9db875187281";
    hash = "sha256-2dHT/p0cImvaJGxf50SSebgq3eSkbX1A0kdi93rCJCE=";
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
