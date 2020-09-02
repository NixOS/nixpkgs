{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fb7l1h4dhn100y2ydq50cgj63fbr4p11x8h803rv6x3xwmviwcg";
  };

  vendorSha256 = "06xlwygqw3kzbjqlx09rs9hl4pfsmay5pj4c5hvkrj5z123ldvyw";

  # No tests
  doCheck = false;

  subPackages = [ "cmd/pdfcpu" ];

  meta = with stdenv.lib; {
    description = "A PDF processor written in Go";
    homepage = "https://pdfcpu.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
