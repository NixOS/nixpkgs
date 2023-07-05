{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "uni";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "uni";
    rev = "v${version}";
    sha256 = "kWiglMuJdcD7z2MDfz1MbItB8r9BJ7LUqfPfJa8QkLA=";
  };

  vendorSha256 = "6HNFCUSJA6oduCx/SCUQQeCHGS7ohaWRunixdwMurBw=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/arp242/uni";
    description = "Query the Unicode database from the commandline, with good support for emojis";
    license = licenses.mit;
    maintainers = with maintainers; [ chvp ];
  };
}
