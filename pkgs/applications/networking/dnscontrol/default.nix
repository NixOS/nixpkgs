{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XBpdNQHG90rJWGfXpJgXsj5AR2VhK/3+1U7Zl8XDlsw=";
  };

  vendorSha256 = "sha256-Ob4ZPtP14TsNOnGVfR5lFAKpJsjoJDKmiE++DqY32QA=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
