{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "pkgsite";
  version = "0-unstable-2025-02-14";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "dd488e5da97a2d18430760c4558bf0b6be1a4bfd";
    hash = "sha256-1tzoHN9kXFkTwwH6loMnagbYX6s9YPhSPXgw/groklE=";
  };

  vendorHash = "sha256-Zb0rhIgdP5Ct8ypuEwRBrN2k+UZ6bZceI3B1XAMC0dk=";

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
