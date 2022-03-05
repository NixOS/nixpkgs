{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sptlrx";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "raitonoberu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b38DACSdnjwPsLMrkt0Ubpqpn/4SDAgrdSlp9iAcxfE=";
  };

  vendorSha256 = "sha256-/fqWnRQBpLNoTwqrFDKqQuv1r9do1voysBhLuj223S0=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Spotify lyrics in your terminal";
    homepage = "https://github.com/raitonoberu/sptlrx";
    license = licenses.mit;
    maintainers = with maintainers; [ MoritzBoehme ];
  };
}
