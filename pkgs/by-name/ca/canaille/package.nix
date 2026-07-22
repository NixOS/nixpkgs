{
  lib,
  python3,
  fetchFromGitLab,
  fetchpatch2,
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

  patches = [
    # Backport authlib 1.7 compatibility.
    (fetchpatch2 {
      url = "https://gitlab.com/yaal/canaille/-/commit/b356baa82109a7fdf61a8258572d199ffd3c9604.diff";
      hash = "sha256-/U6S3h6qIl763ZsGpOm6CVk4NaY3A7mq3PkT193aLEs=";
    })
    # Update OIDC tests for authlib 1.7 behavior.
    (fetchpatch2 {
      url = "https://gitlab.com/yaal/canaille/-/commit/c1b6d103ebf374cd6a21d9af8376c910c2d0d5d9.diff";
      hash = "sha256-MjwkUb54ikt1+xUXBTOIBi9E+DmPdwYhw0W0c0prF/Q=";
      includes = [ "tests/oidc/*" ];
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

  # Cap xdist workers; concurrent slapd fixtures race the 10s bind window.
  dontUsePytestXdist = true;
  pytestFlags = [ "--numprocesses=4" ];

  disabledTests = [
    # Tries to use DNS resolution
    "test_send_new_email_error"
    "test_send_test_email_ssl"
    # flaky: timing-sensitive intruder lockout retry window
    "test_intruder_lockout_fail_second_attempt_then_succeed_in_third"
    # requires external network for logo fetch
    "test_mail_with_unreachable_external_logo"
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
