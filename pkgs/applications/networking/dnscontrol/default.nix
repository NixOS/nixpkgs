{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g3Yb0LAa9Ukp32p0OoXxjmw9RQwyVpi0KXQBIpKunbU=";
  };

  vendorSha256 = "sha256-RBe9XzvdgE5XWBTUhvAokElNwARgwVhkMwPmdKUroC0=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
