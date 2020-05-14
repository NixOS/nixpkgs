{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "0i7sg3iwxb07gjxcz6chpdcx3fqykzldmf7s1c9m02hkps910ca8";
  };

  modSha256 = "19qdrrwmjc32nw8m0zi251z32wqj2d956wgd1dkcvx1x0n4p435g";

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
