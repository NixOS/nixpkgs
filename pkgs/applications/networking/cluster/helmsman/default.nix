{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "0hw2j8bfrlc73q5sxcsj3r2vcsl93cxszfky0svafzgr0a9rnn6z";
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
