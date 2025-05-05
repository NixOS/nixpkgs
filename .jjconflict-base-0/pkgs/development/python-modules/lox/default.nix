{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  pathos,
  pytestCheckHook,
  pytest-mock,
  setuptools,
  tqdm,
}:

buildPythonPackage rec {
  pname = "lox";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BrianPugh";
    repo = "lox";
    tag = "v${version}";
    hash = "sha256-I/+/wl+H3OLAN26qJVqyqgW72GoTddm59j2Y6fsz8AM=";
  };

  build-system = [ setuptools ];

  dependencies = [ pathos ];

  # setup.py requires pytest-runner for setuptools, which is wrong
  postPatch = ''
    substituteInPlace setup.py --replace-fail '"pytest-runner",' ""
  '';

  pythonImportsCheck = [ "lox" ];

  disabledTests = [
    # Benchmark, performance testing
    "test_perf_lock"
    "test_perf_qlock"

    # time sensitive testing
    "test_bathroom_example"
    "test_RWLock_r"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    tqdm
  ];

  meta = {
    description = "Threading and Multiprocessing made easy";
    changelog = "https://github.com/BrianPugh/lox/releases/tag/${src.tag}";
    homepage = "https://github.com/BrianPugh/lox";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.greg ];
  };
}
