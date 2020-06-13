{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbec";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "1lf9srkmi7r6p3him19akzag13hj8arwlkm9mdy8a8fg1ascqbm4";
  };

  vendorSha256 = "1cyr621fb6hxwswz9lf75brc9qjy1n9rqjkwi6r8s3y6nhw20db6";

  meta = with lib; {
    description = "Configure kubernetes objects on multiple clusters using jsonnet https://qbec.io";
    homepage = "https://github.com/splunk/qbec";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}