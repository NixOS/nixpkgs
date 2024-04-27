{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "flood";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hth8tk2DHuBGNAXdjknbdQinuwWJ//QF0e23neeTExw=";
  };

  npmDepsHash = "sha256-WlQ/u7yIbuFETsmbW7ddAOO7OVrNPOXR3ja3N0aFWRE=";

  meta = with lib; {
    description = "Modern web UI for various torrent clients with a Node.js backend and React frontend";
    homepage = "https://flood.js.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ thiagokokada winter ];
    mainProgram = "flood";
  };
}
