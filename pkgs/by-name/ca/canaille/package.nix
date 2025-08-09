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
  version = "0.0.74";
  pyproject = true;

  disabled = python.pythonOlder "3.10";

  src = fetchFromGitLab {
    owner = "yaal";
    repo = "canaille";
    rev = "refs/tags/${version}";
    hash = "sha256-FL02ADM7rUU43XR71UWr4FLr/NeUau7zRwTMOSFm1T4=";
  };

  patches = [
    # https://gitlab.com/yaal/canaille/-/merge_requests/275
    (fetchpatch {
      url = "https://gitlab.com/yaal/canaille/-/commit/1c7fc8b1034a4423f7f46ad8adeced854910b702.patch";
      hash = "sha256-fu7D010NG7yUChOve7HY3e7mm2c/UGpfcTAiTU8BnGg=";
    })
  ];

  build-system = with python.pkgs; [
    hatchling
    babel
    setuptools
  ];

  dependencies =
    with python.pkgs;
    [
      blinker
      flask
      flask-caching
      flask-wtf
      pydantic-settings
      httpx
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
      pytest-cov-stub
      pytest-httpserver
      pytest-lazy-fixtures
      pytest-smtpd
      pytest-xdist
      scim2-tester
      slapd
      toml
      faker
      time-machine
      pytest-scim2-server
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
    export CONFIG=tests/app/fixtures/default-config.toml
  '';

  optional-dependencies = with python.pkgs; {
    front = [
      email-validator
      flask-babel
      flask-talisman
      flask-themer
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
      httpx
      scim2-models
      authlib
      scim2-client
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
    server = [ hypercorn ];
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
