{
  lib,
  python3,
  fetchFromGitLab,
  fetchpatch,
  openldap,
  nixosTests,
}:

let
  python = python3;
in
python.pkgs.buildPythonApplication rec {
  pname = "canaille";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "yaal";
    repo = "canaille";
    tag = version;
    hash = "sha256-X3EmoOJlGPysTD2v+7K/L4rkgWoVHfNZH1tefxeYFD0=";
  };

  patches = [
    # Fix test_intruder_lockout_two_consecutive_fails
    (fetchpatch {
      url = "https://gitlab.com/yaal/canaille/-/commit/d616095a8a425890c5bab69e9a1fe5eb729fee9a.patch";
      hash = "sha256-sGkqaBBmorWmSwMiZolvtRd/WGDaxmDiPmZyPh+otvU=";
    })
  ];

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
    flask-wtf
    httpx
    pika
    pydantic-settings
    wtforms
  ];

  nativeCheckInputs =
    with python.pkgs;
    [
      pytestCheckHook
      coverage
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

  # For now, just the memory backend passes the tests. The goal is to at least
  # get the sql backend work too.
  pytestFlags = [ "--backend memory" ];

  disabledTests = [
    # Tries to use DNS resolution
    "test_send_new_email_error"
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
    ldap = [ python-ldap ];
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
    sms = [ smpplib ];
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
    changelog = "https://gitlab.com/yaal/canaille/-/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ erictapen ];
    mainProgram = "canaille";
  };

}
