{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  crossplane,
  fetchFromGitHub,
  jellyfish,
  jproperties,
  jsonschema-specifications,
  jsonschema,
  luhn,
  lxml,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  semgrep,
  setuptools,
  six,
  soupsieve,
  wrapt,
}:

buildPythonPackage rec {
  pname = "whispers";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.1";

  src = fetchFromGitHub {
    owner = "adeptex";
    repo = "whispers";
    tag = version;
    hash = "sha256-hmFz6RI52CylsBIqO14hFX+2bvrPjpUBnfoDyVh9TbU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    crossplane
    jellyfish
    jproperties
    jsonschema
    jsonschema-specifications
    luhn
    lxml
    pyyaml
    semgrep
    six
    soupsieve
    wrapt
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Pinning tests highly sensitive to semgrep version
    "tests/unit/plugins/test_semgrep.py"
  ];

  preCheck = ''
    # Pinning test highly sensitive to semgrep version
    substituteInPlace tests/unit/test_main.py \
      --replace-fail '("--ast", 434),' ""

    # Some tests need the binary available in PATH
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "whispers" ];

  meta = with lib; {
    description = "Tool to identify hardcoded secrets in static structured text";
    homepage = "https://github.com/adeptex/whispers";
    changelog = "https://github.com/adeptex/whispers/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "whispers";
  };
}
