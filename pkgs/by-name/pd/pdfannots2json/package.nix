{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfannots2json";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "mgmeyers";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-qk4OSws/6SevN/Q0lsyxw+fZkm2uy1WwOYYL7CB7QUk=";  # Replace with the correct sha256
  };

  vendorHash = null;

  meta = with lib; {
    homepage = "https://github.com/mgmeyers/pdfannots2json";
    license = licenses.agpl3;
    description = "A tool to convert PDF annotations to JSON";
    maintainers = with maintainers; [ _0nyr ];
  };
}
