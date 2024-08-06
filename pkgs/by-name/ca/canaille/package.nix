{
  lib,
  python3,
  fetchFromGitLab,
}:

let
  python = python3.override {
    packageOverrides = final: prev: {
      sentry-sdk = prev.sentry-sdk.overridePythonAttrs (old: {
        dependencies = old.dependencies ++ prev.sentry-sdk.optional-dependencies.flask;
      });
      # coverage = prev.coverage.overridePythonAttrs (old: {
      #   dependencies = (old.dependencies or []) ++ prev.coverage.optional-dependencies.toml;
      # });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "canaille";
  version = "0.0.54";
  pyproject = true;

  disabled = python.pkgs.pythonOlder "3.9";

  src = fetchFromGitLab {
    owner = "yaal";
    repo = "canaille";
    rev = version;
    sha256 = "sha256-MowvgZsb4i0hsqQbOsPl0dbLxxW0J1KAqAz2xEQ+Yks=";
  };

  # See https://github.com/NixOS/nixpkgs/issues/103325
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry>=1.0.0" "poetry-core" \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  build-system = with python.pkgs; [
    poetry-core
    setuptools
    babel
  ];

  dependencies = with python.pkgs; [
    flask
    flask-wtf
    pydantic-settings
    wtforms
  ];

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
    coverage
    # flask-webtest
    pyquery
    pytest-cov
    pytest-httpserver
    pytest-lazy-fixtures
    pytest-smtpd
    pytest-xdist
    slapd
    toml
  ];

  passthru.optional-dependencies = with python.pkgs; {
    front = [
      email-validator
      flask-babel
      flask-themer
      pycountry
      pytz
      toml
    ];
    oidc = [ authlib ];
    ldap = [ python-ldap ];
    sentry = [ sentry-sdk ];
    sql = [
      passlib
      sqlalchemy
      sqlalchemy-json
      sqlalchemy-utils
    ];
  };

}
