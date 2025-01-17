{
  lib,
  python3,
  fetchFromGitLab,
  openldap,
  nixosTests,
}:

let
  python = python3;
in
python.pkgs.buildPythonApplication rec {
  pname = "canaille";
  version = "0.0.56";
  pyproject = true;

  disabled = python.pythonOlder "3.10";

  src = fetchFromGitLab {
    owner = "yaal";
    repo = "canaille";
    rev = "refs/tags/${version}";
    hash = "sha256-cLsLwttUDxMKVqtVDCY5A22m1YY1UezeZQh1j74WzgU=";
  };

  build-system = with python.pkgs; [
    hatchling
    babel
    setuptools
  ];

  dependencies =
    with python.pkgs;
    [
      flask
      flask-wtf
      pydantic-settings
      wtforms
    ]
    ++ sentry-sdk.optional-dependencies.flask;

  nativeCheckInputs =
    with python.pkgs;
    [
      pytestCheckHook
      coverage
      flask-webtest
      pyquery
      pytest-cov
      pytest-httpserver
      pytest-lazy-fixtures
      pytest-smtpd
      pytest-xdist
      slapd
      toml
      faker
      time-machine
    ]
    ++ optional-dependencies.front
    ++ optional-dependencies.oidc
    ++ optional-dependencies.ldap
    ++ optional-dependencies.postgresql;

  postInstall = ''
    mkdir -p $out/etc/schema
    cp $out/${python.sitePackages}/canaille/backends/ldap/schemas/* $out/etc/schema/
  '';

  preCheck = ''
    # Needed by tests to setup a mockup ldap server.
    export BIN="${openldap}/bin"
    export SBIN="${openldap}/bin"
    export SLAPD="${openldap}/libexec/slapd"
    export SCHEMA="${openldap}/etc/schema"

    # Just use their example config for testing
    export CONFIG=canaille/config.sample.toml
  '';

  optional-dependencies = with python.pkgs; {
    front = [
      email-validator
      flask-babel
      flask-themer
      pycountry
      pytz
      toml
      zxcvbn-rs-py
    ];
    oidc = [ authlib ];
    ldap = [ python-ldap ];
    sentry = [ sentry-sdk ];
    postgresql = [
      passlib
      sqlalchemy
      sqlalchemy-json
      sqlalchemy-utils
    ] ++ sqlalchemy.optional-dependencies.postgresql;
  };

  passthru = {
    inherit python;
    tests = {
      inherit (nixosTests) canaille;
    };
  };

  meta = with lib; {
    description = "Lightweight Identity and Authorization Management";
    homepage = "https://canaille.readthedocs.io/en/latest/index.html";
    changelog = "https://gitlab.com/yaal/canaille/-/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ erictapen ];
    mainProgram = "canaille";
  };

}
