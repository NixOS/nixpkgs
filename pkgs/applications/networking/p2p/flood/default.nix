{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "flood";
  version = "unstable-2023-06-03";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = pname;
    rev = "2b652f8148dab7134eeeb201b9d81dd6b8bda074";
    hash = "sha256-wI6URPGUZUbydSgNaHN2C5IA2x/HHjBWIRT6H6iZU/0=";
  };

  npmDepsHash = "sha256-XmDnvq+ni5TOf3UQFc4JvGI3LiGpjbrLAocRvrW8qgk=";

  meta = with lib; {
    description = "Modern web UI for various torrent clients with a Node.js backend and React frontend";
    homepage = "https://flood.js.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ thiagokokada winter ];
    mainProgram = "flood";
  };
}
