{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I1PaDHPocQuoSOyfnxDWwIR+7S9l/odX4SCeAae/jv8=";
  };

  vendorSha256 = "sha256-H0i5MoVX5O0CgHOvefDEyzBWvBZvJZUrC9xBq9CHgeE=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
