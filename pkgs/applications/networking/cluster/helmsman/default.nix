{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-QyxluxAwhEZrgfMWlxB7sUZi6XGCFNGhhWRw3RmnhKM=";
  };

  vendorSha256 = "sha256-gkzDecVvHZPFWDSi8nLw2mkR4HK0+pClpaHcdFFOnF8=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
