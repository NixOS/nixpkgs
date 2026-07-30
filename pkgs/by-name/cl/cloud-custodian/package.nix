{
  lib,
  python3,
  fetchFromGitHub,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "cloud-custodian";
  version = "0.9.51.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cloud-custodian";
    repo = "cloud-custodian";
    tag = finalAttrs.version;
    hash = "sha256-vL+/Sof61EkVjudwyFnYnkFi2Hggx9NFrvY8nRTaU+0=";
  };

  pythonRelaxDeps = [
    "docutils"
    "importlib-metadata"
    "referencing"
    "tabulate"
    "urllib3"
  ];

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    argcomplete
    boto3
    botocore
    certifi
    docutils
    importlib-metadata
    jsonpatch
    cryptography
    jsonschema
    python-dateutil
    pyyaml
    tabulate
    urllib3
  ];

  pythonImportsCheck = [
    "c7n"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  preVersionCheck = ''
    version=${lib.versions.pad 3 finalAttrs.version}
  '';

  meta = {
    description = "Rules engine for cloud security, cost optimization, and governance";
    homepage = "https://cloudcustodian.io";
    changelog = "https://github.com/cloud-custodian/cloud-custodian/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ jlesquembre ];
    license = lib.licenses.asl20;
    mainProgram = "custodian";
  };
})
