{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "13b1ncpx189ca0h70j5cdp0jwlj95kasysryz1l6g13cwn9n6mii";
  };

  vendorSha256 = "11w9i1829hk1qb9w24dyxv1bi49358a274g60x11fp5x5cw7bqa7";

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
