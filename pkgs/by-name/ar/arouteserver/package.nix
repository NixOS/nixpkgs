{
  lib,
  python3Packages,
  fetchFromGitHub,
  bgpq4,
}:

python3Packages.buildPythonPackage rec {
  pname = "arouteserver";
  version = "1.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pierky";
    repo = "arouteserver";
    tag = "v${version}";
    hash = "sha256-Z7d/g1Nn8nn48puCm4OpehtfzE44k7mvTej+ERJlVo4=";
  };

  postPatch = ''
    substituteInPlace tests/static/test_irr_queries_failover.py --replace-fail 'bgpq4 -h' '${lib.getExe bgpq4} -h'

    substituteInPlace pierky/arouteserver/builder.py pierky/arouteserver/config/program.py tests/static/test_cfg_program.py \
      --replace-fail '"bgpq4"' '"${lib.getExe bgpq4}"'
  '';

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = [ "packaging" ];

  dependencies = with python3Packages; [
    aggregate6
    jinja2
    pyyaml
    requests
    packaging
    urllib3
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "pierky"
    "pierky.arouteserver"
  ];

  enabledTestPaths = [ "tests/static" ];

  disabledTests = [
    # disable copyright year check of files
    "current_year"
    # tries to connect to mock.codes/429 over the network
    "test_peeringdb_429_handling"
  ];

  meta = {
    description = "Automatically build (and test) feature-rich configurations for BGP route servers";
    mainProgram = "arouteserver";
    homepage = "https://github.com/pierky/arouteserver";
    changelog = "https://github.com/pierky/arouteserver/blob/v${version}/CHANGES.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      marcel
      johannwagner
    ];
  };
}
