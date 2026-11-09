{
  lib,
  writeText,
  fetchFromGitHub,
  nixosTests,
  python3,
}:
let
  py = python3.override {
    self = py;
    packageOverrides = final: prev: {
      django = prev.django_6;
    };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "healthchecks";
  version = "5.0.3";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "healthchecks";
    repo = "healthchecks";
    tag = "v${version}";
    sha256 = "sha256-usTbAmxHr+B6pRKxtOsNobVyJr72sGvWq9kB7vbFRdA=";
  };

  propagatedBuildInputs = with py.pkgs; [
    aiosmtpd
    apprise
    cronsim
    django
    django-compressor
    django-stubs-ext
    fido2
    minio
    oncalendar
    psycopg2
    pycurl
    pydantic
    pyjwt
    pyotp
    segno
    statsd
    whitenoise
  ];

  localSettings = writeText "local_settings.py" ''
    import os

    STATIC_ROOT = os.getenv("STATIC_ROOT")
  '';

  installPhase = ''
    mkdir -p $out/opt/healthchecks
    cp -r . $out/opt/healthchecks
    chmod +x $out/opt/healthchecks/manage.py
    cp ${localSettings} $out/opt/healthchecks/hc/local_settings.py
  '';

  passthru = {
    # PYTHONPATH of all dependencies used by the package
    pythonPath = py.pkgs.makePythonPath propagatedBuildInputs;

    tests = {
      inherit (nixosTests) healthchecks;
    };
  };

  meta = {
    homepage = "https://github.com/healthchecks/healthchecks";
    description = "Cron monitoring tool written in Python & Django";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      debtquity
    ];
  };
}
