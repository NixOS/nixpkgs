{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "nali";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    sha256 = "sha256-WAYNSIv4/eJfjJLej7msgat8nRm4r+xidHrFvL/OocA=";
  };

  vendorSha256 = "sha256-YTzuOhJQN/BCgGQnA9sKNz0OIut/mCj1eXwfEh9gxTA=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "An offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [ diffumist xyenon ];
  };
}
