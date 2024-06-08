{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "starlark";
  version = "0-unstable-2023-11-21";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "90ade8b19d09805d1b91a9687198869add6dfaa1";
    hash = "sha256-ZNOPx7L21A4BR5WshMMAHGm6j1ukWC9waJ1lYLvxBw0=";
  };

  vendorHash = "sha256-jQE5fSqJeiDV7PW7BY/dzCxG6b/KEVIobcjJsaL2zMw=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/google/starlark-go";
    description = "An interpreter for Starlark, implemented in Go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "starlark";
  };
}
