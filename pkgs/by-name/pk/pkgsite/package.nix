{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-12-09";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "7dafa59905aea1f9f4a8d2f38c1505796d9b69b3";
    hash = "sha256-aNpvU/4FFNDJAn11Js+1I41GjLic6gF8MyJXS3TLeRA=";
  };

  vendorHash = "sha256-6wgJNDzUzSCkwzjqGwzpa63+0HoN5PapKxMBFBuu16M=";

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
