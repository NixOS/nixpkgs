{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "0h89lgp3n7nd7dy8nq4bfxg938imdjsvs1k6yg8j37vgdmi24sa6";
  };

  vendorSha256 = "05vnysr5r3hbayss1pyifgp989kjw81h95iack8ady62k6ys5njl";

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
