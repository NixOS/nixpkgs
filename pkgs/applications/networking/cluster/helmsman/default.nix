{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "0vng0ra8bjxmfq6xvdxn72f5bcjrv8i72dams80lf0mq3l7wjl7c";
  };

  vendorSha256 = "05vnysr5r3hbayss1pyifgp989kjw81h95iack8ady62k6ys5njl";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
