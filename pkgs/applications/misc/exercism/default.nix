{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "exercism";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner  = "exercism";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "sha256-9GdkQaxYvxMGI5aFwUtQnctjpZfjZaKP3CsMjC/ZBSo";
  };

  vendorSha256 = "sha256-EW9SNUqJHgPQlNpeErYaooJRXGcDrNpXLhMYpmZPVSw";

  doCheck = false;

  subPackages = [ "./exercism" ];

  meta = with lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso maintainers.nobbz ];
  };
}
