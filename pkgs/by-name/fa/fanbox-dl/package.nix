{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fanbox-dl";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${version}";
    hash = "sha256-hHjkV/wv+UMO4pyWDyMio3XbiyM6M02eLcT2rauvh/A=";
  };

  vendorHash = "sha256-o1DFHwSpHtbuU8BFcrk18hPRJJkeoPkYnybIz22Blfk=";

  # pings websites during testing
  doCheck = false;

  meta = with lib; {
    description = "Pixiv FANBOX Downloader";
    homepage = "https://github.com/hareku/fanbox-dl";
    license = licenses.mit;
    maintainers = [ maintainers.moni ];
  };
}
