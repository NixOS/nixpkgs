{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
<<<<<<< HEAD
  perl,
  radicale,
  which,
  xandikos,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calendar-cli";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tobixen";
    repo = "calendar-cli";
    rev = "v${version}";
    hash = "sha256-w35ySLnfxXZR/a7BrPLYqXs2kqkuYhh5PcgNxJqjDtE=";
  };

<<<<<<< HEAD
  postPatch = ''
    patchShebangs tests
    substituteInPlace tests/test_calendar-cli.sh \
      --replace-fail "../bin/calendar-cli.py" "$out/bin/calendar-cli" \
      --replace-fail "../bin/calendar-cli" "$out/bin/calendar-cli"
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    vobject
  ];

  nativeCheckInputs = [
    perl
    (python3.pkgs.toPythonModule (radicale.override { inherit python3; }))
    which
    xandikos
  ];

  checkPhase = ''
    runHook preCheck

    pushd tests
    ./test_calendar-cli.sh
    popd

    runHook postCheck
  '';
=======
  ];

  # tests require networking
  doCheck = false;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.tests = {
    inherit (nixosTests) radicale;
  };

<<<<<<< HEAD
  meta = {
    description = "Simple command-line CalDav client";
    homepage = "https://github.com/tobixen/calendar-cli";
    license = lib.licenses.gpl3Plus;
    mainProgram = "calendar-cli";
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    description = "Simple command-line CalDav client";
    homepage = "https://github.com/tobixen/calendar-cli";
    license = licenses.gpl3Plus;
    mainProgram = "calendar-cli";
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
