{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "puncia";
  version = "0.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ARPSyndicate";
    repo = "puncia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-woy8JL+yFOYUsAhYWxyskUj/hT3JmwrhKHg3JHyWzNY=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "puncia" ];

  meta = {
    description = "CLI utility for Subdomain Center & Exploit Observer";
    homepage = "https://github.com/ARPSyndicate/puncia";
    changelog = "https://github.com/ARPSyndicate/puncia/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "puncia";
  };
})
