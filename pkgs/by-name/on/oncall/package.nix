{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
  oncall,
  nixosTests,

  # Override Python packages using
  # self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
  # Applied after defaultOverrides
  packageOverrides ? self: super: { },
}:
let
  defaultOverrides = [
    # Override the version of some packages pinned in Oncall's setup.py
    (self: super: {
      # Support for Falcon 4.X missing
      # https://github.com/linkedin/oncall/issues/430
      falcon = super.falcon.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.3";
        src = fetchFromGitHub {
          owner = "falconry";
          repo = "falcon";
          tag = version;
          hash = "sha256-7719gOM8WQVjODwOSo7HpH3HMFFeCGQQYBKktBAevig=";
        };
      });
    })
  ];

  python = python3.override {
    self = python;
    packageOverrides = lib.composeManyExtensions (defaultOverrides ++ [ packageOverrides ]);
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "oncall";
  version = "2.1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "linkedin";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-oqzU4UTpmAcZhqRilquxWQVyHv8bqq0AGraiSqwauiI=";
  };

  patches = [
    # Add support for loading extra settings file
    ./support_extra_config.patch

    # Support storing assets in custom state dir
    ./support_custom_state_dir.patch

    # Log Python errors to uwsgi
    ./verbose_logging.patch
  ];

  dependencies = with python.pkgs; [
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

  checkInputs = with python.pkgs; [
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
    inherit python;
    pythonPath = "${python.pkgs.makePythonPath dependencies}:${oncall}/${python.sitePackages}";
  };

  meta = {
    description = "A calendar web-app designed for scheduling and managing on-call shifts";
    homepage = "http://oncall.tools";
    changelog = "https://github.com/linkedin/oncall/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "oncall";
  };
}
