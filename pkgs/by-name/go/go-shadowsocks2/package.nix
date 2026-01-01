{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-shadowsocks2";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "go-shadowsocks2";
    rev = "v${version}";
    sha256 = "sha256-z2+5q8XlxMN7x86IOMJ0qbrW4Wrm1gp8GWew51yBRFg=";
  };

  vendorHash = "sha256-RrHksWET5kicbdQ5HRDWhNxx4rTi2zaVeaPoLdg4uQw=";

<<<<<<< HEAD
  meta = {
    description = "Fresh implementation of Shadowsocks in Go";
    homepage = "https://github.com/shadowsocks/go-shadowsocks2/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oxzi ];
=======
  meta = with lib; {
    description = "Fresh implementation of Shadowsocks in Go";
    homepage = "https://github.com/shadowsocks/go-shadowsocks2/";
    license = licenses.asl20;
    maintainers = with maintainers; [ oxzi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "go-shadowsocks2";
  };
}
