{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-el94Iq7/+1FfGpqbhKEO6FGpaCxoueoc/+Se+WfT+G0=";
  };

  vendorSha256 = "sha256-MSHg1RWjbXm1pf6HTyJL4FcnLuacL9fO1F6zbouVkWg=";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w" ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
