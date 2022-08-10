{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "dnscontrol";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-n4reCWoGDn1sQ99FaFvglRXRnXPwlQU64NqVU+V+s7Q=";
  };

  vendorSha256 = "sha256-+HkJypEc0CizQSQKwoUr4MbQdHK07cFPpNw9OaIoJJI=";

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    # requires network
    rm pkg/spflib/flatten_test.go pkg/spflib/parse_test.go
  '';

  meta = with lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut SuperSandro2000 ];
  };
}
