{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.4.6";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "018bkl6q6q8njv9qy87affs0g6c716vmhcqv2czv8qz454hn7i5h";
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
