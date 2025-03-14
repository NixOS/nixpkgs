{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ejson";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "ejson";
    rev = "v${version}";
    sha256 = "sha256-s/VeBajNZI0XNs1PwWMpHAF0Wrh1/ZQUvUZBnUCoPBM=";
  };

  vendorHash = "sha256-JeZkiiqNmDsuQSA6hCboasApRlTmw/+fgTAp5WbgdDg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Small library to manage encrypted secrets using asymmetric encryption";
    mainProgram = "ejson";
    license = licenses.mit;
    homepage = "https://github.com/Shopify/ejson";
    maintainers = [ maintainers.manveru ];
  };
}
