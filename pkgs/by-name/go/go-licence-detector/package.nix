{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-licence-detector";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "go-licence-detector";
    rev = "v${version}";
    hash = "sha256-/94rUYWS8r8rRTmMyNs93voLdK3WlzJlIQWxgGE6eaQ=";
  };

  vendorHash = "sha256-wJ6jB8MxyYOlOpABRv5GmULofWuPQR8yClj63qsr/tg=";

  meta = with lib; {
    description = "Detect licences in Go projects and generate documentation";
    homepage = "https://github.com/elastic/go-licence-detector";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
