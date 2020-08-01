{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pdfcpu";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "pdfcpu";
    repo = pname;
    rev = "v${version}";
    sha256 = "00c4psgfh4hia144zsdhrq83bw3fqda1ancv2gkn5ymxkbpnpyrn";
  };

  vendorSha256 = "09alkpfyxapycv6zsaz7prgbr0a1jzd78n7w2mh01mg4hhb2j3k7";

  subPackages = [ "cmd/pdfcpu" ];

  meta = with stdenv.lib; {
    description = "A PDF processor written in Go";
    homepage = "https://pdfcpu.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}
