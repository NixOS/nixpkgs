{
  lib,
  fetchFromGitHub,
  python3,
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # Requires 'cyclonedx-python-lib = ">=6.0.0,<8.0.0"'
      cyclonedx-python-lib = super.cyclonedx-python-lib.overridePythonAttrs (oldAttrs: rec {
        version = "7.6.2";
        src = fetchFromGitHub {
          owner = "CycloneDX";
          repo = "cyclonedx-python-lib";
          tag = "v${version}";
          hash = "sha256-nklizCiu7Nmynjd5WU5oX/v2TWy9xFVF4GkmCwFKZLI=";
        };

        # The `serializable` package eventually got renamed `py_serializable`, therefore we need
        # to patch the imports;
        # _c.f._ https://github.com/madpah/serializable/pull/155 .
        postPatch = ''
          find . -name '*.py' | xargs -I{} sed -i \
            -e 's/serializable\./py_serializable\./g' \
            -e 's/@serializable/@py_serializable/g' \
            -e 's/from serializable/from py_serializable/g' \
            -e 's/import serializable/import py_serializable/g' \
            {}
        '';
      });
    };
  };
in
with py.pkgs;

python3.pkgs.buildPythonApplication rec {
  pname = "checkov";
  version = "3.2.474";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = "checkov";
    tag = version;
    hash = "sha256-q0knnfogAPTqzEluOyU4OwXWnFYPilW9/NtuhZd50GA=";
  };

  pythonRelaxDeps = [
    "asteval"
    "bc-detect-secrets"
    "bc-python-hcl2"
    "boto3"
    "botocore"
    "cachetools"
    "cloudsplaining"
    "dpath"
    "igraph"
    "importlib-metadata"
    "license-expression"
    "networkx"
    "openai"
    "packageurl-python"
    "packaging"
    "pycep-parser"
    "rustworkx"
    "schema"
    "termcolor"
    "urllib3"
  ];

  pythonRemoveDeps = [
    # pythonRelaxDeps doesn't work with that one
    "pycep-parser"
  ];

  build-system = with py.pkgs; [ setuptools-scm ];

  dependencies = with py.pkgs; [
    aiodns
    aiohttp
    aiomultiprocess
    argcomplete
    asteval
    bc-detect-secrets
    bc-jsonpath-ng
    bc-python-hcl2
    boto3
    cachetools
    charset-normalizer
    cloudsplaining
    colorama
    configargparse
    cyclonedx-python-lib
    docker
    dockerfile-parse
    dpath
    flake8
    gitpython
    igraph
    jmespath
    jsonschema
    junit-xml
    license-expression
    networkx
    openai
    packaging
    policyuniverse
    prettytable
    pycep-parser
    pyyaml
    pydantic
    rustworkx
    semantic-version
    spdx-tools
    tabulate
    termcolor
    tqdm
    typing-extensions
    update-checker
  ];

  nativeCheckInputs = with py.pkgs; [
    aioresponses
    distutils
    mock
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
    responses
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # No API key available
    "api_key"
    # Requires network access
    "TestSarifReport"
    "test_skip_mapping_default"
    # Flake8 test
    "test_file_with_class"
    "test_dataclass_skip"
    "test_typing_class_skip"
    # Tests are comparing console output
    "cli"
    "console"
    # Assertion error
    "test_runner"
    "test_same_resources_in_report_and_coordinator"
    # AssertionError: assert ['<?xml versi...
    "test_get_cyclonedx_report"
    # Test fails on Hydra
    "test_sast_js_filtered_files_by_ts"
    # Timing sensitive
    "test_non_multiline_pair_time_limit_creating_report"
  ];

  disabledTestPaths = [
    # Tests are pulling from external sources
    # https://github.com/bridgecrewio/checkov/blob/f03a4204d291cf47e3753a02a9b8c8d805bbd1be/.github/workflows/build.yml
    "integration_tests/"
    "tests/ansible/"
    "tests/arm/"
    "tests/bicep/"
    "tests/cloudformation/"
    "tests/common/"
    "tests/dockerfile/"
    "tests/generic_json/"
    "tests/generic_yaml/"
    "tests/github_actions/"
    "tests/github/"
    "tests/kubernetes/"
    "tests/sca_package_2"
    "tests/terraform/"
    "cdk_integration_tests/"
    "sast_integration_tests"
    # Performance tests have no value for us
    "performance_tests/test_checkov_performance.py"
    # No Helm
    "dogfood_tests/test_checkov_dogfood.py"
  ];

  pythonImportsCheck = [ "checkov" ];

  postInstall = ''
    chmod +x $out/bin/checkov
  '';

  meta = {
    description = "Static code analysis tool for infrastructure-as-code";
    homepage = "https://github.com/bridgecrewio/checkov";
    changelog = "https://github.com/bridgecrewio/checkov/releases/tag/${version}";
    longDescription = ''
      Prevent cloud misconfigurations during build-time for Terraform, Cloudformation,
      Kubernetes, Serverless framework and other infrastructure-as-code-languages.
    '';
    mainProgram = "checkov";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      anhdle14
      fab
    ];
  };
}
