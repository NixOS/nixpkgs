{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
  perl,
  radicale,
  versionCheckHook,
  which,
  xandikos,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "calendar-cli";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycalendar";
    repo = "calendar-cli";
    # https://github.com/pycalendar/calendar-cli/pull/113#issuecomment-3977892432
    tag = "v0.15.0";
    hash = "sha256-P6ClvX6C5VargAvudgSvBwObIUouTRg7SQ62KxhcKiE=";
  };

  postPatch = ''
    substituteInPlace calendar_cli/metadata.py \
      --replace-fail '"version": "1.0.1"' '"version": "${finalAttrs.version}"'

    patchShebangs tests
    substituteInPlace tests/test_calendar-cli.sh \
      --replace-fail "../bin/calendar-cli.py" "$out/bin/calendar-cli" \
      --replace-fail "../bin/calendar-cli" "$out/bin/calendar-cli"
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    icalendar
    caldav
    pytz
    pyyaml
    tzlocal
    click
    six
    urllib3
    vobject
  ];

  nativeCheckInputs = [
    perl
    (python3.pkgs.toPythonModule (radicale.override { inherit python3; }))
    versionCheckHook
    which
    xandikos
  ];

  checkPhase = ''
    runHook preCheck
    runHook preInstallCheck

    pushd tests
    ./test_calendar-cli.sh
    popd

    runHook postCheck
    runHook postInstallCheck
  '';

  passthru.tests = {
    inherit (nixosTests) radicale;
  };

  meta = {
    changelog = "https://github.com/pycalendar/calendar-cli/releases/tag/${finalAttrs.src.tag}";
    description = "Simple command-line CalDav client";
    homepage = "https://github.com/pycalendar/calendar-cli";
    license = lib.licenses.gpl3Plus;
    mainProgram = "calendar-cli";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
