{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ad-miner";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mazars-Tech";
    repo = "AD_Miner";
    tag = "v${version}";
    hash = "sha256-iI7jiENPYCIVJnIG/M4ft4dkR2Ja21gzR+ISeyZvUEo=";
  };

  # All requirements are pinned
  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    neo4j
    numpy
    pytz
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ad_miner" ];

  meta = {
    description = "Active Directory audit tool that leverages cypher queries to crunch data from Bloodhound";
    homepage = "https://github.com/Mazars-Tech/AD_Miner";
    changelog = "https://github.com/Mazars-Tech/AD_Miner/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "AD-miner";
  };
}
