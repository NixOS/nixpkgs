{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "glab";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "profclems";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NSc/h6cENuXIBwC4ixvZDlERV7b/X0GB4OGzxGEk4YY=";
  };

  vendorSha256 = "sha256-N9swoVltKzdYez1WSoXMLZCvfYSFhVXgPjUfR0+5aAo=";
  runVend = true;

  # Tests are trying to access /homeless-shelter
  doCheck = false;

  subPackages = [ "cmd/glab" ];

  meta = with lib; {
    description = "An open-source GitLab command line tool";
    license = licenses.mit;
    homepage = "https://glab.readthedocs.io/";
    maintainers = with maintainers; [ freezeboy ];
  };
}
