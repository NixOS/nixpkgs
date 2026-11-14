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
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycalendar";
    repo = "calendar-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5qPBHwOPW/HsmO/jBMyq6ROb23JYfJ/XLWmHwgb5kPY=";
  };

  postPatch = ''
    patchShebangs tests
    substituteInPlace tests/test_calendar-cli.sh \
      --replace-fail "../bin/calendar-cli.py" "$out/bin/calendar-cli"
  '';

  __darwinAllowLocalNetworking = true;

  build-system = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3.pkgs; [
    icalendar
    caldav
    pytz
    pyyaml
    tzlocal
    click
    six
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
