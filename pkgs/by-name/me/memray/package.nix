{
  lib,
  elfutils,
  fetchFromGitHub,
  libunwind,
  lz4,
  pkg-config,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "memray";
  version = "1.15.0-unstable-2025-02-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "memray";
    #tag = "v${version}";
    rev = "460f914b0539d6a9b9e8de348909c5f69acf5ead";
    hash = "sha256-l2P36bd13TeOAQOVlik525+ZqRpWXkbM8IQCHh4NB/s=";
  };

  build-system = with python3Packages; [
    distutils
    setuptools
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libunwind
    lz4
    elfutils # for `-ldebuginfod`
  ] ++ (with python3Packages; [ cython ]);

  dependencies = with python3Packages; [
    pkgconfig
    textual
    jinja2
    rich
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      ipython
      pytest-cov # fix Unknown pytest.mark.no_cover
      pytest-textual-snapshot
      pytestCheckHook
    ]
    ++ lib.optionals (pythonOlder "3.14") [ greenlet ];

  pythonImportsCheck = [ "memray" ];

  pytestFlagsArray = [ "tests" ];

  disabledTests = [
    # Import issue
    "test_header_allocator"
    "test_hybrid_stack_of_allocations_inside_ceval"
  ];

  disabledTestPaths = [
    # Very time-consuming and some tests fails (performance-related?)
    "tests/integration/test_main.py"
  ];

  meta = {
    description = "Memory profiler for Python";
    homepage = "https://bloomberg.github.io/memray/";
    changelog = "https://github.com/bloomberg/memray/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
}
