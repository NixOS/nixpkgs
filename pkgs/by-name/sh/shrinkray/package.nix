{
  coreutils,
  creduce,
  fetchFromGitHub,
  lib,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "shrinkray";
  version = "25.9.1-unstable-2025-09-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DRMacIver";
    repo = "shrinkray";
    rev = "21dac48cdb7f3a375a4ac5e5c782b7d4d3711d36";
    hash = "sha256-ef0vsWfLl0hJ7WfwInh++GAbw3qTZe8RAVNLxQCTNNs=";
  };
  patches = [ ./tests-remove-black.patch ];
  postPatch = ''
    substituteInPlace tests/test_main.py \
      --replace-fail '/usr/bin/env' '${coreutils}/bin/env'
  '';

  build-system = [ python3.pkgs.setuptools ];
  propagatedBuildInputs = with python3.pkgs; [
    click
    chardet
    trio
    urwid
    humanize
    libcst
    exceptiongroup
    binaryornot
  ];
  checkInputs = with python3.pkgs; [
    hypothesis
    hypothesmith
    pytest-trio
    pygments
  ];
  nativeCheckInputs = with python3.pkgs; [
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
