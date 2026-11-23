{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ad-miner";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AD-Security";
    repo = "AD_Miner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OCNwX72LgFRXdz2DrM64kHSfHtQchk5MAzQRyUZTV+w=";
  };

  # All requirements are pinned
  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    neo4j
    numpy
    pytz
    requests
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ad_miner" ];

  meta = {
    description = "Active Directory audit tool that leverages cypher queries to crunch data from Bloodhound";
    homepage = "https://github.com/AD-Security/AD_Miner";
    changelog = "https://github.com/AD-Security/AD_Miner/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "AD-miner";
  };
})
