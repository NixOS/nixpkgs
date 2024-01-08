{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication {
  pname = "mediawiki-dump-generator";
  version = "unstable-2023-12-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mediawiki-client-tools";
    repo = "mediawiki-dump-generator";
    rev = "e19ffbc13278c09400600dfc4a2c006ad74fa663";
    hash = "sha256-fxpywv1W3XFnCIwOw9JByFahJWeWIOjMK79X5a3SjBo=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    file-read-backwards
    internetarchive
    lxml
    mwclient
    pre-commit-poetry-export
    pymysql
    pywikibot
    requests
    urllib3
    wikitools3
  ];

  pythonImportsCheck = [ "wikiteam3" ];

  meta = with lib; {
    description = "Python 3 tools for downloading and preserving wikis";
    homepage = "https://github.com/mediawiki-client-tools/mediawiki-dump-generator";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ TheBrainScrambler ];
    mainProgram = "dumpgenerator";
  };
}
