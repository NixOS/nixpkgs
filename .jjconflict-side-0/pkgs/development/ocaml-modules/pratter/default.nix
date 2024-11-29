{ lib
, fetchFromGitHub
, buildDunePackage
, camlp-streams
, alcotest
, qcheck
, qcheck-alcotest
}:

buildDunePackage rec {
  version = "2.0.0";
  pname = "pratter";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "gabrielhdt";
    repo = "pratter";
    rev = version;
    hash = "sha256-QEq8Zt2pfsRT04Zd+ugGKcHdzkqYcDDUg/iAFMMDdEE=";
  };

  propagatedBuildInputs = [ camlp-streams ];

  checkInputs = [ alcotest qcheck qcheck-alcotest ];
  doCheck = true;

  meta = with lib; {
    description = "Extended Pratt parser";
    homepage = "https://github.com/gabrielhdt/pratter";
    license = licenses.bsd3;
    changelog = "https://github.com/gabrielhdt/pratter/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ bcdarwin ];
  };
}
