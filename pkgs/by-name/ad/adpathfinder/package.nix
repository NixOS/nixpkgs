{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "adpathfinder";
  version = "1.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NetSPI";
    repo = "AD-PathFinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UZMULUs/0zm7iU7nh5E3z1oKHRMmUG6pYsYudNWaL/E=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    argcomplete
    beautifulsoup4
    colorama
    neo4j
    prompt-toolkit
    requests
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Attack path mapping for Active Directory, ADCS, SCCM and MSSQL";
    homepage = "https://github.com/NetSPI/AD-PathFinder";
    changelog = "https://github.com/NetSPI/AD-PathFinder/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "adpathfinder";
  };
})
