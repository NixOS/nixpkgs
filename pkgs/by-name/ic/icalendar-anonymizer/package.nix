{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "icalendar-anonymizer";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycalendar";
    repo = "icalendar-anonymizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LoRIDUOXhSjJ4ymQrbEG6sH9rQF6HJVZ/R+A8TlYmi8=";
  };

  postPatch = ''
    # If we don't replace {commit_hash}, `hatch-vcs` will attempt to call
    # `git rev-parse` and fail. It's simpler for us to substitute it here.
    substituteInPlace pyproject.toml \
      --replace-fail \
        'source_archive = "https://github.com/pycalendar/icalendar-anonymizer/archive/{commit_hash}.zip"' \
        'source_archive = "https://github.com/pycalendar/icalendar-anonymizer/archive/${finalAttrs.src.rev}.zip"'
  '';

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  dependencies =
    with python3Packages;
    [
      icalendar
    ]
    ++ finalAttrs.passthru.optional-dependencies.cli
    ++ finalAttrs.passthru.optional-dependencies.web;

  optional-dependencies = with python3Packages; {
    cli = [
      click
    ];
    test = [
      click
      coverage
      hypothesis
      pytest-asyncio
      pytest-cov
      pytest-httpx
    ];
    web = [
      fastapi
      httpx
      python-multipart
      uvicorn
    ];
  };

  pythonImportsCheck = [
    "icalendar_anonymizer"
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
    ]
    ++ finalAttrs.passthru.optional-dependencies.test;

  postInstall = ''
    makeWrapper ${python3Packages.uvicorn}/bin/uvicorn $out/bin/icalendar-anonymizer-web \
      --prefix PYTHONPATH : ${python3.pkgs.makePythonPath finalAttrs.passthru.dependencies} \
      --prefix PYTHONPATH : $out/${python3.sitePackages} \
      --set-default ICALENDAR_ANONYMIZER_HOST "0.0.0.0" \
      --set-default ICALENDAR_ANONYMIZER_PORT "8000" \
      --add-flags '--host "$ICALENDAR_ANONYMIZER_HOST"' \
      --add-flags '--port "$ICALENDAR_ANONYMIZER_PORT"' \
      --add-flags "icalendar_anonymizer.webapp.main:app"
  '';

  meta = {
    description = "Privacy-focused iCalendar file anonymizer";
    homepage = "https://docs.icalendar-anonymizer.com/stable/index.html";
    changelog = "https://github.com/pycalendar/icalendar-anonymizer/blob/${finalAttrs.src.rev}/CHANGES.rst";
    license =
      with lib.licenses;
      AND [
        agpl3Plus
        bsd3 # docs/_static/js/custom-icons.js
      ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "icalendar-anonymizer";
  };
})
