{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "nali";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "zu1k";
    repo = "nali";
    rev = "v${version}";
    sha256 = "sha256-7NUUX4hDwvMBBQvxiB7P/lNHKgxwOFObdD6DUd0vX5c=";
  };

  vendorSha256 = "sha256-Ld5HehK5MnPwl6KtIl0b4nQRiXO4DjKVPL1iti/WBIQ=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "An offline tool for querying IP geographic information and CDN provider";
    homepage = "https://github.com/zu1k/nali";
    license = licenses.mit;
    maintainers = with maintainers; [ diffumist xyenon ];
  };
}
