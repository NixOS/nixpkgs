{
  lib,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  python3,
}:

let
  python = python3;

in
python.pkgs.buildPythonApplication rec {
  pname = "otterwiki";
  version = "2.20.5";
  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redimp";
    repo = "otterwiki";
    tag = "v${version}";
    hash = "sha256-Yov80c5LjofVMh45uz4gVUF7nTiy/tNB9wEyVM/ppro=";
  };

  build-system = with python.pkgs; [ setuptools ];

  pythonRelaxDeps = true;
  dependencies = with python.pkgs; [
    werkzeug
    flask-login
    flask-mail
    flask-wtf
    sqlalchemy
    flask-sqlalchemy
    flask
    jinja2
    gitpython
    cython
    mistune
    pygments
    pillow
    pyyaml
    unidiff
    beautifulsoup4
    pluggy
    regex
    feedgen
  ];

  passthru = {
    inherit python;
    wsgiModule = "otterwiki.server:app";
    updateScript = nix-update-script { };
    tests.simple = nixosTests.otterwiki;
  };

  meta = {
    description = "Minimalistic wiki powered by python, markdown and git";
    homepage = "https://otterwiki.com/";
    changelog = "https://github.com/redimp/otterwiki/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
  };
}
