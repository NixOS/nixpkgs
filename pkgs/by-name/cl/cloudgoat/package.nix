{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "cloudgoat";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhinoSecurityLabs";
    repo = "cloudgoat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y41Q6mVt0XY8nZnRGTXdc0HaQapd55FUe8mhwU0NKrM=";
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
    changelog = "https://github.com/RhinoSecurityLabs/cloudgoat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cloudgoat";
  };
})
