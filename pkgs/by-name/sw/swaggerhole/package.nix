{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "swaggerhole";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Liodeus";
    repo = "swaggerhole";
    # Source is not tagged at the moment, https://github.com/Liodeus/swaggerHole/issues/2
    rev = "14846406fbd0f145d71ad51c3b87f383e4afbc3b";
    hash = "sha256-3HmIpn1A86PXZRL+SqMdr84O16hW1mCUWHKnOVolmx8=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    requests
    whispers
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "swaggerhole"
  ];

  meta = with lib; {
    description = "Tool to searching for secret on swaggerhub";
    mainProgram = "swaggerhole";
    homepage = "https://github.com/Liodeus/swaggerHole";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
