{
  lib,
  python3Packages,
  fetchFromGitHub,
  gfortran,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ford";
  version = "7.0.13";

  src = fetchFromGitHub {
    owner = "Fortran-FOSS-Programmers";
    repo = "ford";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+pz4YvMmr7QIqrORJg0F2W7m20FTrItHCC+AmcDp284=";
  };

  pyproject = true;

  nativeBuildInputs = [ python3Packages.pythonRelaxDepsHook ];

  pythonRelaxDeps = [
    "markdown"
    "markdown-include"
    "toposort"
    "graphviz"
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    markdown
    markdown-include
    toposort
    jinja2
    pygments
    beautifulsoup4
    graphviz
    tqdm
    tomli
    rich
    pcpp
    python-markdown-math
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    tomli-w
    pcpp
    gfortran
  ];

  meta = {
    description = "Fortran documentation system";
    mainProgram = "ford";
    homepage = "https://github.com/Fortran-FOSS-Programmers/ford";
    license = [ lib.licenses.gpl3Only ];
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
