{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.6.7";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-6w2CV6Uj1b8b3vwB933eNHPe1rK+TRyUL++Vy38cKqo=";
  };

  vendorSha256 = "sha256-icX8mOc8g+DhfAjD1pzneLWTXY17lXyAjdPOWAxkHwI=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
