{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kb";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gnebbia";
    repo = "kb";
    tag = "v${version}";
    hash = "sha256-X2yFQYH4nqI5CqPtKFHq3+V/itqTpUho9en4WEIRjQM=";
  };

  postPatch = ''
    # `attr` module is not available. And `attrs` defines another `attr` package
    # that shadows it.
    substituteInPlace setup.py \
      --replace-fail \
        "install_requires=[\"colored\",\"toml\",\"attr\",\"attrs\",\"gitpython\"]," \
        "install_requires=[\"colored\",\"toml\",\"attrs\",\"gitpython\"],"
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    colored
    toml
    attrs
    gitpython
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kb" ];

  meta = {
    description = "Minimalist command line knowledge base manager";
    longDescription = ''
      kb is a text-oriented minimalist command line knowledge base manager. kb
      can be considered a quick note collection and access tool oriented toward
      software developers, penetration testers, hackers, students or whoever has
      to collect and organize notes in a clean way. Although kb is mainly
      targeted on text-based note collection, it supports non-text files as well
      (e.g., images, pdf, videos and others).
    '';
    homepage = "https://github.com/gnebbia/kb";
    changelog = "https://github.com/gnebbia/kb/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wesleyjrz ];
    mainProgram = "kb";
  };
}
