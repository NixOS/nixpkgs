{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "flood";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BR+ZGkBBfd0dSQqAvujsbgsEPFYw/ThrylxUbOksYxM=";
  };

  npmDepsHash = "sha256-tuEfyePwlOy2/mOPdXbqJskO6IowvAP4DWg8xSZwbJw=";

  NODE_OPTIONS = "--openssl-legacy-provider";

  meta = with lib; {
    description = "Modern web UI for various torrent clients with a Node.js backend and React frontend";
    homepage = "https://flood.js.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ thiagokokada winter ];
  };
}
