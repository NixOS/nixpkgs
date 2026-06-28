{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.2.0-unstable-2026-06-18";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "78ee7d155e76c298e91b46983873b8dff09e8bb6";
    hash = "sha256-0cPo7MrRNT8W0E6hyLy6WzB0hfv7OqDhz92UtJPLY34=";
  };

  vendorHash = "sha256-pamVUaMpkNVGY9tWPHsIiqflthzwELFOxgn90ncor/U=";

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
