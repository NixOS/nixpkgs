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
  version = "1.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bloomberg";
    repo = "memray";
    tag = "v${version}";
    hash = "sha256-bShFMuDJlvBA3rQJRwXlsgRk4q+gdFQjOpDzOrp4/8k=";
  };

  # AttributeError: 'Label' object has no attribute 'renderable'.
  # In textual==0.6.0, the `renderable` property was renamed to `content`
  # https://github.com/Textualize/textual/pull/6041
  postPatch = ''
    substituteInPlace tests/unit/test_tui_reporter.py \
      --replace-fail ".renderable" ".content"
  '';

  build-system = with python3Packages; [
    distutils
    setuptools
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    elfutils # for `-ldebuginfod`
    libunwind
    lz4
  ]
  ++ (with python3Packages; [ cython ]);

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
      pytest-cov-stub # fix Unknown pytest.mark.no_cover
      pytest-textual-snapshot
      pytestCheckHook
    ]
    ++ lib.optionals (pythonOlder "3.14") [ greenlet ];

  pythonImportsCheck = [ "memray" ];

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # Import issue
    "test_header_allocator"
    "test_hybrid_stack_of_allocations_inside_ceval"

    # The following snapshot tests started failing since updating textual to 3.5.0
    "TestTUILooks"
    "test_merge_threads"
    "test_tui_basic"
    "test_tui_gradient"
    "test_tui_pause"
    "test_unmerge_threads"
  ];

  disabledTestPaths = [
    # Very time-consuming and some tests fails (performance-related?)
    "tests/integration/test_main.py"
  ];

  meta = {
    description = "Memory profiler for Python";
    homepage = "https://bloomberg.github.io/memray/";
    changelog = "https://github.com/bloomberg/memray/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
}
