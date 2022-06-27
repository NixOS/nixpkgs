{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "nali";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    sha256 = "sha256-91y+k/IFi66xIHbO6URYKSSEdWPg+h/DVu4BV50+Q7g=";
  };

  ldflags = [ "-X 'github.com/zu1k/nali/internal/constant.Version=${version}'" "-w" "-s" ];
  vendorSha256 = "sha256-ghbPHgMNV5sgVhp2f0RXblBknYLYzDqZ4F9odl7YeKk=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "An offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [ diffumist xyenon ];
  };
}
