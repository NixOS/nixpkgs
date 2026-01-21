{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cloud-custodian";
  version = "0.9.38.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloud-custodian";
    repo = "cloud-custodian";
    tag = version;
    hash = "sha256-jGWPwHiETS4+hk9euLLxs0PBb7mxz2PHCbYYlFfLQUw=";
  };

  pythonRelaxDeps = [
    "docutils"
    "importlib-metadata"
    "referencing"
    "urllib3"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    argcomplete
    boto3
    botocore
    certifi
    docutils
    importlib-metadata
    jsonpatch
    jsonschema
    python-dateutil
    pyyaml
    tabulate
    urllib3
  ];

  # Requires tox, many packages, and network access
  checkPhase = ''
    $out/bin/custodian --help
  '';

  meta = {
    description = "Rules engine for cloud security, cost optimization, and governance";
    homepage = "https://cloudcustodian.io";
    changelog = "https://github.com/cloud-custodian/cloud-custodian/releases/tag/${version}";
    license = lib.licenses.asl20;
    mainProgram = "custodian";
  };
}
