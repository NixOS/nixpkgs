{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.15.1";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-LgfYcptC1fcINf80dbOZu8HD5oTrF0tTMQCWdsO3H5U=";
  };

  vendorSha256 = "sha256-iEsblhejczTFPL7LvEKHE/T1h2xAt7cdnoR8KIv3Wpo=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
