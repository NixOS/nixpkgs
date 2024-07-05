{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ad-miner";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mazars-Tech";
    repo = "AD_Miner";
    rev = "refs/tags/v${version}";
    hash = "sha256-BSUMNVHhclHzQf3Z0p2ZZjfQIZQyc2ZeQ67PXRz1RBk=";
  };

  # All requirements are pinned
  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [
    poetry-core
  ];

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  dependencies = with python3.pkgs; [
    neo4j
    numpy
    pytz
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ad_miner"
  ];

  meta = with lib; {
    description = "Active Directory audit tool that leverages cypher queries to crunch data from Bloodhound";
    homepage = "https://github.com/Mazars-Tech/AD_Miner";
    changelog = "https://github.com/Mazars-Tech/AD_Miner/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "AD-miner";
  };
}
