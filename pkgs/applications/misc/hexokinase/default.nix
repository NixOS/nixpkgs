{ lib
, buildGoModule
, fetchFromGitHub
, go
}:

buildGoModule rec {
  pname = "hexokinase";
  version = "2020-08-24";

  src = fetchFromGitHub {
    owner = "RRethy";
    repo = "hexokinase";
    rev = "11fc3efc6752b580083ea7891db8216377571b6d";
    sha256 = "sha256-m+8G24WEzAXLWEDwxVmGOErECE1KV73tO3dvSByhwYw=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  meta = with lib; {
    description = "Fast text scraper to find and convert colours into hex values";
    homepage = "https://github.com/RRethy/hexokinase";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani ];
  };
}
