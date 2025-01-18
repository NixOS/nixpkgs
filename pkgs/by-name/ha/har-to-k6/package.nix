{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "har-to-k6";
  version = "0.14.8";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jfMfuEVY/wcM8tHM6cHRSpcUUMGvfu31NniUvtct2zY=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-PCLCDmuFFd2lcIpFoeYNvL3DVo55GoLcLP6SnAu67NM=";

  meta = {
    description = "Converts LI-HAR and HAR to K6 script";
    homepage = "https://github.com/grafana/har-to-k6";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cterence ];
  };
}
