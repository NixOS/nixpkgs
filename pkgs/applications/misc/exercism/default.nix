{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

buildGoModule rec {
  pname = "exercism";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "exercism";
    repo  = "cli";
    rev   = "v${version}";
    hash  = "sha256-9GdkQaxYvxMGI5aFwUtQnctjpZfjZaKP3CsMjC/ZBSo=";
  };

  vendorHash = "sha256-EW9SNUqJHgPQlNpeErYaooJRXGcDrNpXLhMYpmZPVSw=";

  doCheck = false;

  subPackages = [ "./exercism" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso maintainers.nobbz ];
  };
}
