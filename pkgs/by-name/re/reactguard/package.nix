{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "reactguard";
  version = "0.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theori-io";
    repo = "reactguard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ysXdqMny6c1ATTpjI4Ev4T1yjs2jNu4mf7azO/IsAKI=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    httpx
    typing-extensions
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-cov-stub
    pytest-xdist
  ];

  pythonImportsCheck = [ "reactguard" ];

  meta = {
    description = "Vulnerability detection tool for CVE-2025-55182 (React2Shell";
    homepage = "https://github.com/theori-io/reactguard";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "reactguard";
  };
})
