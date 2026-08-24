{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0.4.0-unstable-2026-08-19";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "ac4376fe69c9ad5618c5c50d5382edf7fd93ea49";
    hash = "sha256-xm9LlGPn0tUf1Yqb01Ihdxu71ByP8ZS7L04Dajqages=";
  };

  vendorHash = "sha256-HSEroer2bQbXWFBW9whOOebTvxW+QuzcPCd9XOya5r4=";

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
