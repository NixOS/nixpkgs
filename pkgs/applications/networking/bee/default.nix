{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bee";
  version = "0.1.0";

  subPackages = [
    "cmd/bee"
  ];

  vendorSha256 = "1a9fmf5c3asvylcb0ixlwb6jk2z5hzdaa6yffg1pjvq9rx92jbjy";

  src = fetchFromGitHub {
    owner = "ethersphere";
    repo = "bee";
    rev = "v${version}";
    sha256 = "1iwwhs2zm8ml484sc0d7smmmp1x893zjafr1mnaswl8pxg0lnm2l";
  };

  meta = with stdenv.lib; {
    homepage = "https://swarm-gateways.net/bzz:/docs.swarm.eth/";
    description = "Ethereum Swarm Bee";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ paulperegud ];
  };
}
