{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-03-09";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "59cb58a646844f6fba00bfadc39b4bea96357358";
    hash = "sha256-CsKdUrgnjs11iVdfUwgiO9KTx1TCfqFljiFqiAYxoK4=";
  };

  vendorHash = "sha256-G/XTWobysyzONctabYDIfAQ/zaAA9w2Ky7Hn6cj9l/c=";

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
