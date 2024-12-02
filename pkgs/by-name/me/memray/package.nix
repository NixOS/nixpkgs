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
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "memray";
    rev = "refs/tags/v${version}";
    hash = "sha256-U9JR60rSxPYXbZaKR7vVNhGT78AXnqcoqvVC6/1OW/E=";
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
    ++ lib.optionals (pythonOlder "3.12") [ greenlet ];

  pythonImportsCheck = [ "memray" ];

  pytestFlagsArray = [ "tests" ];

  disabledTests = [
    # Import issue
    "test_header_allocator"
    "test_hybrid_stack_of_allocations_inside_ceval"

    # snapshot-based tests are too fragile
    # see https://github.com/bloomberg/memray/issues/654
    "TestTUILooks"
    "test_tui_basic"
    "test_tui_pause"
    "test_tui_gradient"
    "test_merge_threads"
    "test_unmerge_threads"
  ];

  disabledTestPaths = [
    # Very time-consuming and some tests fails (performance-related?)
    "tests/integration/test_main.py"
  ];

  meta = with lib; {
    description = "Memory profiler for Python";
    homepage = "https://bloomberg.github.io/memray/";
    changelog = "https://github.com/bloomberg/memray/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
