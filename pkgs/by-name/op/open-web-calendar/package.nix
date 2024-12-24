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
python.pkgs.buildPythonApplication rec {
  pname = "open-web-calendar";
  version = "1.42";
  pyproject = true;

  disabled = python.pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "open_web_calendar";
    hash = "sha256-w4XaT1+qIM80K6B+LIAeYdZzYIw4FYSd/nvWphOx460=";
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
  ];

  dependencies =
    with python.pkgs;
    [
      flask-caching
      flask-allowed-hosts
      flask
      icalendar
      requests
      pyyaml
      recurring-ical-events
      gunicorn
      lxml
      beautifulsoup4
      lxml-html-clean
      pytz
    ]
    ++ requests.optional-dependencies.socks;

  nativeCheckInputs = with python.pkgs; [ pytestCheckHook ];

  pytestFlagsArray = [ "open_web_calendar/test" ];

  pythonImportsCheck = [ "open_web_calendar.app" ];

  defaultSpecificationPath = "${python.sitePackages}/open_web_calendar/default_specification.yml";

  passthru = {
    inherit python;
    tests = {
      inherit (nixosTests) open-web-calendar;
    };
  };

  meta = with lib; {
    description = "Highly customizable web calendar that can be embedded into websites using ICal source links";
    homepage = "https://open-web-calendar.quelltext.eu";
    changelog =
      let
        v = builtins.replaceStrings [ "." ] [ "" ] version;
      in
      "https://open-web-calendar.quelltext.eu/changelog/#v${v}";
    license = with licenses; [
      gpl2Only
      cc-by-sa-40
      cc0
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ erictapen ];
    mainProgram = "open-web-calendar";
  };
}
