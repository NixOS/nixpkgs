{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
  oncall,
  nixosTests,
  fetchpatch,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "oncall";
  # Using newer revision for Falcon 4 patch to work
  version = "0-unstable-2025-04-15";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "linkedin";
    repo = "oncall";
    #tag = "v${version}";
    rev = "030f5d0286b253e4300d36de1954c7b2a7490a76";
    hash = "sha256-Lox9aqYKsl/vg6mNwr0MoLmJQkC+kEf7AqvCCKhgo94=";
  };

  patches = [
    # Add support for loading extra settings file
    ./support_extra_config.patch

    # Support storing assets in custom state dir
    ./support_custom_state_dir.patch

    # Log Python errors to uwsgi
    ./verbose_logging.patch

    # Add support for Falcon 4
    # https://github.com/linkedin/oncall/pull/433
    (fetchpatch {
      url = "https://github.com/linkedin/oncall/commit/4ccf2239fb8c8aeda376f57735461174f48614f2.patch";
      hash = "sha256-XT7Z6NUg2zxoRtgxaM0ZbBhXtO9xvhKv30Jo1ZaEGMU=";
      name = "falcon_4_support.patch";
    })
  ];

  dependencies = with python3.pkgs; [
    beaker
    falcon
    falcon-cors
    gevent
    gunicorn
    icalendar
    irisclient
    jinja2
    phonenumbers
    pymysql
    python-ldap
    pytz
    pyyaml
    ujson
    webassets
  ];

  postInstall = ''
    mkdir "$out/share"
    cp -r configs db "$out/share/"
  '';

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-mock
  ];

  disabledTestPaths = [
    # Tests require running web server
    "e2e/test_audit.py"
    "e2e/test_events.py"
    "e2e/test_ical.py"
    "e2e/test_login.py"
    "e2e/test_notification.py"
    "e2e/test_override.py"
    "e2e/test_pin.py"
    "e2e/test_populate.py"
    "e2e/test_roles.py"
    "e2e/test_roster_suggest.py"
    "e2e/test_rosters.py"
    "e2e/test_schedules.py"
    "e2e/test_services.py"
    "e2e/test_subscription.py"
    "e2e/test_teams.py"
    "e2e/test_users.py"
  ];

  pythonImportsCheck = [
    "oncall"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) oncall;
    };
    pythonPath = "${python3.pkgs.makePythonPath dependencies}:${oncall}/${python3.sitePackages}";
  };

  meta = {
    description = "Calendar web-app designed for scheduling and managing on-call shifts";
    homepage = "https://oncall.tools";
    changelog = "https://github.com/linkedin/oncall/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "oncall";
  };
}
