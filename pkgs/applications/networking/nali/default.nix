{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "nali";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    sha256 = "sha256-NHTS9YajVjyAjSEQxMqyyY2Hwd30pjnIthZ+1jroqTE=";
  };

  vendorSha256 = "sha256-1sXG/xEzPVN1aRCsYqUee9aidT+ognZszOC7SR8YArw=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "An offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [ diffumist xyenon ];
  };
}
