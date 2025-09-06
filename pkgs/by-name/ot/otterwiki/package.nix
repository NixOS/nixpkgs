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
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redimp";
    repo = "otterwiki";
    rev = "v${version}";
    hash = "sha256-esho5GmzHbCXL1uv0paTFDXHihHWwQqVjRAuOWl3kVk=";
  };

  build-system = with python.pkgs; [ setuptools ];

  pythonRelaxDeps = true;
  dependencies = with python.pkgs; [
    werkzeug
    flask-login
    flask-mail
    sqlalchemy
    flask-sqlalchemy
    flask
    jinja2
    gitpython
    cython
    (callPackage ./mistune.nix { }) # wants an old version of mistune
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
    description = "A minimalistic wiki powered by python, markdown and git";
    homepage = "https://otterwiki.com/";
    changelog = "https://github.com/redimp/otterwiki/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
  };
}
