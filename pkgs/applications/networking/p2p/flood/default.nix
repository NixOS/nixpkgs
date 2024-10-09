{ lib
, buildNpmPackage
, fetchFromGitHub
, nixosTests
}:

buildNpmPackage rec {
  pname = "flood";
  version = "4.8.2";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ejr0pmWIuYByzDS+iFTECO/aymzuJrJjaaW7HikNt2w=";
  };

  npmDepsHash = "sha256-md76I7W5QQvfbOmk5ODssMtJAVOj8nvaJ2PakEZ8WUA=";

  passthru.tests = {
    inherit (nixosTests) flood;
  };

  meta = with lib; {
    description = "Modern web UI for various torrent clients with a Node.js backend and React frontend";
    homepage = "https://flood.js.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ thiagokokada winter ];
    mainProgram = "flood";
  };
}
