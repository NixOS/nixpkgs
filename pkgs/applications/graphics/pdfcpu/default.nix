{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cbbbf93gxx768fs6pldy25xk46k7mc8k94r3f7cd83f1qd3s5zn";
  };

  vendorSha256 = "1i0w4284icbl40yrjny9qd5iqrq18x63lrs7p1gz58nybc606azx";

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
