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
  version = "0.0.57";
  pyproject = true;

  disabled = python.pythonOlder "3.10";

  src = fetchFromGitLab {
    owner = "yaal";
    repo = "canaille";
    rev = "refs/tags/${version}";
    hash = "sha256-pesN7k5kGHi3dqTMaXWdCsNsnaJxXv/Ku1wVC9N9a3k=";
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
      requests
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
      scim2-tester
      slapd
      toml
      faker
      time-machine
    ]
    ++ optional-dependencies.front
    ++ optional-dependencies.oidc
    ++ optional-dependencies.scim
    ++ optional-dependencies.ldap
    ++ optional-dependencies.postgresql
    ++ optional-dependencies.otp
    ++ optional-dependencies.sms;

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
    scim = [
      scim2-models
      authlib
    ];
    ldap = [ python-ldap ];
    sentry = [ sentry-sdk ];
    postgresql = [
      passlib
      sqlalchemy
      sqlalchemy-json
      sqlalchemy-utils
    ] ++ sqlalchemy.optional-dependencies.postgresql_psycopg2binary;
    otp = [
      otpauth
      pillow
      qrcode
    ];
    sms = [ smpplib ];
  };

  passthru = {
    inherit python;
    tests = {
      inherit (nixosTests) canaille;
    };
  };

  disabledTests = [
    # cause by authlib being too up-to-date for this version of canaille
    # see: https://github.com/NixOS/nixpkgs/issues/389861#issuecomment-2726361949
    # FIX: update and see if this is fixed
    "test_invalid_client[ldap_backend]"
    "test_invalid_client[memory_backend]"
    "test_invalid_client[sql_backend]"
    "test_password_reset[sql_backend]"
  ];

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
