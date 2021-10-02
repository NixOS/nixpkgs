{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.7.5";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-QJXCVcEf23oaTDemoCV/2aaajbubfXg0AfZrlSTS4Ag=";
  };

  vendorSha256 = "sha256-4imZrZfpR/5tw9ZFSTr7Gx4G9O1iHNE9YRYMOJFKvHU=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
