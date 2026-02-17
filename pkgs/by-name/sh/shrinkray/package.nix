{
  bash,
  black,
  clang-tools,
  coreutils,
  cvise,
  fetchFromGitHub,
  lib,
  minisat,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "shrinkray";
  version = "26.2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DRMacIver";
    repo = "shrinkray";
    tag = "v${version}";
    hash = "sha256-y8NZJ80KM+wW58YAWT7Cx3uh08imI7sbs487GbANyJg=";
  };
  postPatch = ''
    substituteInPlace tests/test_main.py \
      --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
    substituteInPlace \
      tests/test_cli.py \
      tests/test_history.py \
      tests/test_main.py \
      tests/test_state.py \
      tests/test_subprocess_worker.py \
      tests/test_tui.py \
      tests/test_validation.py \
      --replace-fail '#!/bin/bash' '#!${lib.getExe bash}'
    substituteInPlace src/shrinkray/formatting.py \
      --replace-fail 'find_python_command("black")' '"${lib.getExe black}"' \
      --replace-fail 'which("clang-format")' '"${lib.getExe' clang-tools "clang-format"}"'
    substituteInPlace src/shrinkray/passes/clangdelta.py \
      --replace-fail 'which("clang_delta")' '"${cvise}/libexec/cvise/clang_delta"'
  '';

  build-system = [ python3.pkgs.setuptools ];
  dependencies = with python3.pkgs; [
    click
    chardet
    trio
    textual
    textual-plotext
    humanize
    libcst
    exceptiongroup
    binaryornot
  ];
  propagatedNativeBuildInputs = [
    black
    clang-tools
  ];
  nativeCheckInputs = [
    minisat
  ]
  ++ (with python3.pkgs; [
    hypothesis
    hypothesmith
    pytest-trio
    pytest-textual-snapshot
    pygments
    pexpect
    pyte
    pip
    pytestCheckHook
  ]);

  disabledTestPaths = [
    # Tests pretending these utilities are missing don't pass when we
    # patch in absolute paths
    "tests/test_clang_delta.py::test_find_clang_delta_when_found_in_path"
    "tests/test_clang_delta.py::test_find_clang_delta_when_not_found_anywhere"
    "tests/test_formatting.py::test_default_formatter_python_files_without_black"
  ];

  meta = {
    description = "Modern multi-format test-case reducer";
    license = lib.licenses.mit;
    homepage = "https://github.com/DRMacIver/shrinkray";
    maintainers = [ lib.maintainers.andersk ];
    mainProgram = "shrinkray";
  };
}
