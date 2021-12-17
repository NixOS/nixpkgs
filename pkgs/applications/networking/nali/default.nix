{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "nali";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    sha256 = "sha256-iRLoUBA+Kzv1/LZQ8HCvR79K1riYErxEWhB0OmvFy2g=";
  };

  vendorSha256 = "sha256-Kb2T+zDUuH+Rx8amYsTIhR5L3DIx5nGcDGqxHOn90NU=";
  subPackages = [ "." ];
  runVend = true;

  meta = with lib; {
    description = "An offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [ diffumist ];
  };
}
