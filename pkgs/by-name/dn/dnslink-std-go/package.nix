{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dnslink";
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "dnslink-std";
    repo = "go";
    tag = "v${version}";
    hash = "sha256-aATnNDUogNS4jBoWxUAFYFMa2ZS0+th3XH+1KWqwfWQ=";
  };
  vendorHash = "sha256-RH55yfIO9jHLbjtEdUF5QpL5ILV5ctX2hBYBJWutmUA=";
  doCheck = false; # Uses network, unsuprisingly.
  meta = {
    changelog = "https://github.com/dnslink-std/go/releases/tag/v${version}";
    description = "Reference implementation for DNSLink in golang";
    homepage = "https://dnslink.org/";
    license = lib.licenses.mit;
    mainProgram = "dnslink";
  };
}
