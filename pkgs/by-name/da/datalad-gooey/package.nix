{
  lib,
  git,
  python3,
  fetchFromGitHub,
  fetchpatch,
  darwin,
  stdenv,
  git-annex,
}:

python3.pkgs.buildPythonApplication {
  pname = "datalad-gooey";
  # many bug fixes on `master` but no new release
  version = "unstable-2024-02-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datalad";
    repo = "datalad-gooey";
    rev = "5bd6b9257ff1569439d2a77663271f5d665e61b6";
    hash = "sha256-8779SLcV4wwJ3124lteGzvimDxgijyxa818ZrumPMs4=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    pyside6
    pyqtdarktheme
    datalad-next
    outdated
    datalad
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppleScriptKit ];

  pythonRemoveDeps = [ "applescript" ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    python3.pkgs.pytest-qt
    git
    git-annex
  ];

  pythonImportsCheck = [ "datalad_gooey" ];

  meta = {
    description = "Graphical user interface (GUI) for DataLad";
    homepage = "https://github.com/datalad/datalad-gooey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
    mainProgram = "datalad-gooey";
  };
}
