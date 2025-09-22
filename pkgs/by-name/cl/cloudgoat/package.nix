{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloudgoat";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhinoSecurityLabs";
    repo = "cloudgoat";
    tag = "v${version}";
    hash = "sha256-xDUDpdEluYKudrjIYOoQWNvF8BoC/VpSVdV5pzfLoMc=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    argcomplete
    boto3
    pyyaml
    requests
    sqlite-utils
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "cloudgoat" ];

  meta = {
    description = "AWS deployment tool for a vulnerable environment";
    homepage = "https://github.com/RhinoSecurityLabs/cloudgoat";
    changelog = "https://github.com/RhinoSecurityLabs/cloudgoat/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cloudgoat";
  };
}
