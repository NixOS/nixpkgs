{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "cloudgoat";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhinoSecurityLabs";
    repo = "cloudgoat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-36GgGni4Zds4wZ8PQbrDD7SXwkKYQfcUi7Z//5j9NWU=";
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
