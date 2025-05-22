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
  version = "1.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "memray";
    tag = "v${version}";
    hash = "sha256-n000m2jIJJFZFTjfECS3gFrO6xHauZW46xe1tDqI6Lg=";
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

    # AssertionError since textual was updated to 3.1.0
    # https://github.com/bloomberg/memray/issues/750
    "tests/unit/test_tree_reporter.py"
    "tests/unit/test_tui_reporter.py"
  ];

  meta = with lib; {
    description = "Memory profiler for Python";
    homepage = "https://bloomberg.github.io/memray/";
    changelog = "https://github.com/bloomberg/memray/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
