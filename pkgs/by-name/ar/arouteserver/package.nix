{
  lib,
  python3Packages,
  fetchFromGitHub,
  bgpq4,
}:

python3Packages.buildPythonPackage rec {
  pname = "arouteserver";
  version = "1.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pierky";
    repo = "arouteserver";
    rev = "v${version}";
    hash = "sha256-EZOBMDBsxbuVzzjQWU8V4n3gcLkRQxCq2eVK/Tyko4E=";
  };

  postPatch = ''
    substituteInPlace tests/static/test_irr_queries_failover.py --replace-fail 'bgpq4 -h' '${lib.getExe bgpq4} -h'

    substituteInPlace pierky/arouteserver/builder.py pierky/arouteserver/config/program.py tests/static/test_cfg_program.py \
      --replace-fail '"bgpq4"' '"${lib.getExe bgpq4}"'
  '';

  build-system = with python3Packages; [ setuptools ];

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

  pytestFlagsArray = [ "tests/static" ];

  meta = {
    description = "Automatically build (and test) feature-rich configurations for BGP route servers";
    mainProgram = "arouteserver";
    homepage = "https://github.com/pierky/arouteserver";
    changelog = "https://github.com/pierky/arouteserver/blob/v${version}/CHANGES.rst";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = lib.teams.wdz.members ++ (with lib.maintainers; [ marcel ]);
  };
}
