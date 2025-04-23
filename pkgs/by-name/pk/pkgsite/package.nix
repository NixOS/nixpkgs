{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2025-04-16";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "0a075a2cae6ac8ff829d0d7c7841d064d6833167";
    hash = "sha256-kYmxR6ZzlHDBeAYFDlUN5EcgRDpB/S00Xx3N1MbKsIk=";
  };

  vendorHash = "sha256-JoPuNktN4OsdNJ0e8BRuuD0CKuWiFsAcLAS5h9rH/Z0=";

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
