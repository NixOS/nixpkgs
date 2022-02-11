{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kconf";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "particledecay";
    repo = "kconf";
    rev = "v${version}";
    sha256 = "NlTpHQFOJJcIt/xMT3fvdrlxANyg//wtYMmXzEtaFXo=";
  };

  vendorSha256 = "2d4o87wE9QZltk2YOHc20XVYF8n0EOrDf5mJ6i6EB0c=";

  meta = with lib; {
    description = "An opinionated command line tool for managing multiple kubeconfigs";
    homepage = "https://github.com/particledecay/kconf";
    license = licenses.mit;
    maintainers = with maintainers; [ thmzlt ];
  };
}
