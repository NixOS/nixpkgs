{
  lib,
  python3,
  fetchPypi,
  nixosTests,

  defaultSpecificationFile ? null,
}:

let
  python = python3;
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "open-web-calendar";
  version = "1.51";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "open_web_calendar";
    hash = "sha256-r+7ZKdNOhjnjE1MBNAkni4Rrpx4DMRhUaP1Mmk5wzOo=";
  };

  # The Pypi tarball doesn't contain open_web_calendars/features
  postPatch = ''
    ln -s $PWD/features open_web_calendar/features
  '';

  postInstall = lib.optionalString (defaultSpecificationFile != null) ''
    install -D ${defaultSpecificationFile} $out/$defaultSpecificationPath
  '';

  build-system = with python.pkgs; [
    hatchling
    hatch-vcs
    hatch-requirements-txt
  ];

  dependencies =
    with python.pkgs;
    [
      flask-allowed-hosts
      flask
      icalendar
      icalendar-compatibility
      cryptography
      bcrypt
      caldav
      requests
      requests-cache
      pyyaml
      recurring-ical-events
      gunicorn
      lxml
      beautifulsoup4
      lxml-html-clean
      pytz
      mergecal
    ]
    ++ requests.optional-dependencies.socks;

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
    pytest-responses
  ];

  enabledTestPaths = [ "open_web_calendar/test" ];

  pythonImportsCheck = [ "open_web_calendar.app" ];

  defaultSpecificationPath = "${python.sitePackages}/open_web_calendar/default_specification.yml";

  passthru = {
    inherit python;
    tests = {
      inherit (nixosTests) open-web-calendar;
    };
  };

  meta = {
    description = "Highly customizable web calendar that can be embedded into websites using ICal source links";
    homepage = "https://open-web-calendar.quelltext.eu";
    changelog =
      let
        v = builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version;
      in
      "https://open-web-calendar.quelltext.eu/changelog/#v${v}";
    license = with lib.licenses; [
      gpl2Only
      cc-by-sa-40
      cc0
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ erictapen ];
    mainProgram = "open-web-calendar";
  };
})
