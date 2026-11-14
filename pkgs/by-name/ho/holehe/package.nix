{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "holehe";
  version = "1.61-unstable-2024-09-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "megadose";
    repo = "holehe";
    rev = "14da70f588538936b20d238783c5e28a0772a2b3";
    hash = "sha256-d3j2J5FMNwnL4ux05WQKLBtTFg7QM5zAmVbiFackP2M=";
  };

  postPatch = ''
    # https://github.com/megadose/holehe/pull/178
    substituteInPlace setup.py \
      --replace-fail "bs4" "beautifulsoup4"
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    colorama
    httpx
    termcolor
    tqdm
    trio
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "holehe"
  ];

  meta = {
    description = "CLI to check if the mail is used on different sites";
    mainProgram = "holehe";
    homepage = "https://github.com/megadose/holehe";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
