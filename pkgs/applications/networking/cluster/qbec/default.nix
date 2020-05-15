{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbec";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "0krdfaha19wzi10rh0wfhki5nknbd5mndaxhrq7y9m840xy43d6d";
  };

  vendorSha256 = "1cyr621fb6hxwswz9lf75brc9qjy1n9rqjkwi6r8s3y6nhw20db6";

  meta = with lib; {
    description = "Configure kubernetes objects on multiple clusters using jsonnet https://qbec.io";
    homepage = "https://github.com/splunk/qbec";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}