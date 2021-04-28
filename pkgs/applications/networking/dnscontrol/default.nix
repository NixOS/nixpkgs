{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x002p7wPKbcmr4uE04mgKBagHQV/maEo99Y2Jr7xgK4=";
  };

  vendorSha256 = "sha256-lR5+xVi/ROOFoRWyK0h/8uiSP/joQ9Zr9kMaQ+sWNhM=";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w" ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
