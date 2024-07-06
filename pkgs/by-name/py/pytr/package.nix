{ lib
, python3Packages
, fetchFromGitHub
}:
python3Packages.buildPythonApplication {
  pname = "pytr";
  version = "0.1.9-unstable-2024-04-01";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "marzzzello";
    repo = "pytr";
    rev = "843ba364fb61116effe230a5a65a4116e03e1f34";
    hash = "sha256-GQHNk1BaJLLse8eEELwzgJ/c7f1cpbYJFIkWSaT2yhU=";
  };

  dependencies = with python3Packages; [
    certifi
    coloredlogs
    ecdsa
    packaging
    pathvalidate
    pygments
    requests-futures
    shtab
    websockets
  ];

  meta = with lib; {
    homepage = "https://github.com/marzzzello/pytr";
    description = "Use Trade Republic in terminal and mass download all documents";
    maintainers = with maintainers; [ juliusrickert ];
    platforms = with platforms; linux ++ darwin;
  };
}

