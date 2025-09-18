{
  lib,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  python3,
  fetchPypi,
}:

let
  python = python3;

in
python.pkgs.buildPythonApplication rec {
  pname = "otterwiki";
  version = "2.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redimp";
    repo = "otterwiki";
    tag = "v${version}";
    hash = "sha256-HK9Ep8PYsDcHkmHLcKulpm/1UPpJdzELRZrkVSA4KUg=";
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

    (mistune.overridePythonAttrs (oldAttrs: rec {
      version = "2.0.5";
      src = fetchPypi {
        inherit (oldAttrs) pname;
        inherit version;
        hash = "sha256-AkYRPLJJLbh1xr5Wl0p8iTMzvybNkokchfYxUc7gnTQ=";
      };
    }))

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
