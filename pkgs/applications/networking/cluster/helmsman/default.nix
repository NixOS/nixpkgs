{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.4.4";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "01vjghak2szif0p82kall5jw7mbfh4fg7fcjkblmic7l0vlqhfac";
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
