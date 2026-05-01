{
  lib,
  python3,
  fetchFromGitLab,
  openldap,
  nixosTests,
  postgresql,
}:

let
  python = python3;
in
python.pkgs.buildPythonApplication rec {
  pname = "canaille";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "yaal";
    repo = "canaille";
    tag = version;
    hash = "sha256-hreEjMrD6mRapgrSDPRWcmqfLxfsOpK7dC8lHJkAY7Y=";
  };

  build-system = with python.pkgs; [
    hatchling
    babel
    setuptools
  ];

  dependencies = with python.pkgs; [
    blinker
    click
    dramatiq
    dramatiq-eager-broker
    flask
    flask-caching
    flask-dramatiq
    flask-session
    flask-wtf
    httpx
    pydantic-settings
    wtforms
  ];

  nativeCheckInputs =
    with python.pkgs;
    [
      pytestCheckHook
      postgresql
      flask-webtest
      pyquery
      pytest-cov-stub
      pytest-httpserver
      pytest-lazy-fixtures
      pytest-postgresql
      pytest-smtpd
      pytest-xdist
      python-avatars
      scim2-tester
      slapd
      toml
      faker
      time-machine
      pytest-scim2-server
    ]
    ++ (lib.concatLists (builtins.attrValues optional-dependencies));

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
  '';

  disabledTests = [
    # Tries to use DNS resolution
    "test_send_new_email_error"
    "test_send_test_email_ssl"
  ];

  optional-dependencies = with python.pkgs; {
    front = [
      email-validator
      flask-babel
      flask-talisman
      flask-themer
      isodate
      pycountry
      pytz
      tomlkit
      zxcvbn-rs-py
    ];
    oidc = [
      authlib
      joserfc
    ];
    scim = [
      authlib
      httpx
      scim2-client
      scim2-models
    ];
    ldap = [
      ldappool
      python-ldap
    ];
    sentry = [ sentry-sdk ];
    postgresql = [
      flask-alembic
      passlib
      sqlalchemy
      sqlalchemy-json
      sqlalchemy-utils
    ]
    ++ sqlalchemy.optional-dependencies.postgresql_psycopg2binary;
    otp = [
      otpauth
      pillow
      qrcode
    ];
    fido = [ webauthn ];
    sms = [ smpplib ];
    captcha = [ captcha ];
    server = [
      asgiref
      hypercorn
      isodate
      pydanclick
      tomlkit
    ];
    redis = [ dramatiq ] ++ dramatiq.optional-dependencies.redis;
    rabbitmq = [ dramatiq ] ++ dramatiq.optional-dependencies.rabbitmq;
  };

  passthru = {
    inherit python;
    tests = {
      inherit (nixosTests) canaille;
    };
  };

  meta = {
    description = "Lightweight Identity and Authorization Management";
    homepage = "https://canaille.readthedocs.io/en/latest/index.html";
    changelog = "https://gitlab.com/yaal/canaille/-/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ erictapen ];
    mainProgram = "canaille";
  };

}
