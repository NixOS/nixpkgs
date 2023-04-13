{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "nali";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    sha256 = "sha256-ZJnQiTcfvxHFgRNytQANs/lF4hy0S0cXOy8IuGECYi0=";
  };

  vendorHash = "sha256-TLij88IksL0+pARKVhEhPg6qUPAXMlL2DWJk4ynahUs=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "An offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [ diffumist xyenon ];
  };
}
