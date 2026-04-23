{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-04-17";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "2aebd320af3eaaf0dfd54f655a8e40e033de83f5";
    hash = "sha256-pLplSDXn/TYaj0cA4IvUMOt93H89kQ7Of75ThL+kc1M=";
  };

  vendorHash = "sha256-BbCCOgx6Tis2e07nSftdIi7cv8cHIXlsZl5Qk4fsWh8=";

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
