{
  bash,
  black,
  coreutils,
  creduce,
  fetchFromGitHub,
  lib,
  minisat,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "shrinkray";
  version = "26.1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DRMacIver";
    repo = "shrinkray";
    tag = "v${version}";
    hash = "sha256-nQ1k83z03iP+p4qTqk2X7VWaO3zSr3dl9k4mF3fnF8I=";
  };
  postPatch = ''
    substituteInPlace tests/test_main.py \
      --replace-fail '/usr/bin/env' '${coreutils}/bin/env'
    substituteInPlace \
      tests/test_cli.py \
      tests/test_history.py \
      tests/test_main.py \
      tests/test_state.py \
      tests/test_subprocess_worker.py \
      tests/test_tui.py \
      tests/test_validation.py \
      --replace-fail '#!/bin/bash' '#!${bash}/bin/bash'
  '';

  build-system = [ python3.pkgs.setuptools ];
  propagatedBuildInputs = with python3.pkgs; [
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
    minisat
  ];
  checkInputs = with python3.pkgs; [
    hypothesis
    hypothesmith
    pytest-trio
    pytest-textual-snapshot
    pygments
    pexpect
    pyte
  ];
  nativeCheckInputs = with python3.pkgs; [
    pip
    pytestCheckHook
  ];

  meta = {
    description = "Modern multi-format test-case reducer";
    license = lib.licenses.mit;
    homepage = "https://github.com/DRMacIver/shrinkray";
    maintainers = [ lib.maintainers.andersk ];
    mainProgram = "shrinkray";
  };
}
