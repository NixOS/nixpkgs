{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "nali";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    sha256 = "sha256-mKZQe+VuhXm5N2SAOfHUlPK6wJPa8Cd+wgDjqSGbR7I=";
  };

  vendorSha256 = "sha256-iNgYU/OgdbKscIA9dIVKqV5tiyLaC3Q4D3W1QsW7CWg=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "An offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [ diffumist xyenon ];
  };
}
