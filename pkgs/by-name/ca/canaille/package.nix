{
  lib,
  stdenvNoCC,
  python3,
  fetchFromGitLab,
  cacert,
  openldap,
  nixosTests,
  postgresql,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = _final: prev: {
      wtforms = prev.wtforms_3_3;
    };
  };
  version = "0.4.3";
  src = fetchFromGitLab {
    owner = "yaal";
    repo = "canaille";
    tag = version;
    hash = "sha256-n1CSpbl5KfB/IRXPbUOaFcrlKcEGhM7E4yGN0ulSB3Y=";
  };
  # Canaille uses it's own build hook to fetch NPM dependencies,
  # so we just use that instead of fetchNpmDeps
  frontendDependencies = stdenvNoCC.mkDerivation {
    pname = "canaille-npm-deps";
    inherit version src;

    env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    nativeBuildInputs = [
      (python.withPackages (ps: [ ps.hatchling ]))
      cacert
    ];

    buildPhase = ''
      python -c 'import hatch_build; hatch_build.vendor_static_files()'
    '';

    installPhase = ''
      cp -r canaille/static/vendor $out
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-+Sc9/9ST81mIu2NzpDzEeYwzviUnJ7Q0e1JosvYhWBU=";
  };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "canaille";
  pyproject = true;

  inherit version src;

  postPatch = ''
    ln -s ${frontendDependencies} canaille/static/vendor
  '';

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
    flask-wtforms-htmx
    httpx2
    pydantic-settings
    wtforms
    wtforms-htmx
    wtforms-htmx-components
  ];

  nativeCheckInputs =
    with python.pkgs;
    [
      pytestCheckHook
      postgresql
      cairosvg
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
      pytest-mysql
    ]
    ++ (lib.concatLists (builtins.attrValues finalAttrs.passthru.optional-dependencies));

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
    # The NixOS module uses PostgreSQL, no interest in testing mariadb as a target for now
    "sql:mariadb"
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
      pillow
      pytz
      zxcvbn-rs-py
    ];
    oidc = [
      authlib
      joserfc
      tomlkit
    ];
    scim = [
      authlib
      scim2-client
      scim2-models
      scim2-server
    ]
    ++ scim2-client.optional-dependencies.httpx2;
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
    changelog = "https://gitlab.com/yaal/canaille/-/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ erictapen ];
    mainProgram = "canaille";
  };

})
