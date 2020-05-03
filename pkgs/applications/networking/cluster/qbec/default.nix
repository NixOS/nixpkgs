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

  modSha256 = "1wb15vrkb4ryvrjp68ygmadnf78s354106ya210pnmsbb53rbhaz";

  meta = with lib; {
    description = "Configure kubernetes objects on multiple clusters using jsonnet https://qbec.io";
    homepage = "https://github.com/splunk/qbec";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
