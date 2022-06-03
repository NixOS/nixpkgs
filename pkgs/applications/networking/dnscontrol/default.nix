{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.16.2";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lzE35PT0QLlZ2jftXpDDvr4S3zD1DOpZVXrGGnzvpc8=";
  };

  vendorSha256 = "sha256-M+Kzw2ZmKV527rPUJ1codtXWN0/5tmph7GMBTze4C7c=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
