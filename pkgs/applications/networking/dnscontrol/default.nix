{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ExpwJ4lMrYy1WztYo+RYa9jb8slIa3IJk/SUKA1fBKI=";
  };

  vendorSha256 = "sha256-IXA4YNdWR6DWIH4ceif2XcAdwnMr2kCuG3ozagtzsgo=";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w" ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
