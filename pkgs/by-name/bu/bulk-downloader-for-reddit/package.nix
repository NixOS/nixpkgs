{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "bulk-downloader-for-reddit";
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aliparlakci";
    repo = "bulk-downloader-for-reddit";
    rev = "v${version}";
    hash = "sha256-nmjULsp4xufbAEKlWjbXWTnmv1WfdLJJher2oyr+x0Y=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    beautifulsoup4
    click
    dict2xml
    praw
    pyyaml
    requests
    yt-dlp
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    dev = [
      black
      flake8-pyproject
      isort
      pre-commit
      pytest
      tox
    ];
  };

  pythonImportsCheck = [ "bdfr" ];

  meta = {
    description = "Downloads and archives content from reddit";
    homepage = "https://github.com/aliparlakci/bulk-downloader-for-reddit/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ skamdart ];
    mainProgram = "bdfr";
  };
}
