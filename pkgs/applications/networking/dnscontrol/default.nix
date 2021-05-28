{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lldkx906imwm8mxcfafpanbgaqh0sdm3zdkwkn7j0nmngyncx9p";
  };

  vendorSha256 = "16cc6hb2iwh1zwrrnb7s4dqxqhaj67gq3gfr5xvh5kqafd685hvx";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
