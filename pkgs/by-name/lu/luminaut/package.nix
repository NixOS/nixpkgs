{
  lib,
  fetchFromGitHub,
  nmap,
  python3,
  whatweb,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "luminaut";
  version = "0.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luminaut-org";
    repo = "luminaut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TPb/Rk1cLCwItfsv/R2qyixCXA8aNnltiGePjdpO6GM=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = [
    nmap
    whatweb
  ]
  ++ (with python3.pkgs; [
    boto3
    google-cloud-compute
    google-cloud-logging
    google-cloud-run
    orjson
    python3-nmap
    rich
    shodan
    tqdm
  ]);

  nativeCheckInputs = with python3.pkgs; [
    moto
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "luminaut" ];

  disabledTests = [
    # Tests require setting a region
    "test_explore_region"
    "test_list_security_group_rules"
    "test_setup_client_region"
    "test_skip_resource"
    "test_discover_public_ips_only_runs_if_aws_enabled"
  ];

  meta = {
    description = "Tool to detect exposure of resources deployed in AWS";
    homepage = "https://github.com/luminaut-org/luminaut";
    changelog = "https://github.com/luminaut-org/luminaut/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "luminaut";
  };
})
