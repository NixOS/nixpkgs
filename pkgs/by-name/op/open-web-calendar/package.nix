{
  lib,
  python3,
  fetchPypi,
  nixosTests,
}:

let
  python = python3;
in
python.pkgs.buildPythonApplication rec {
  pname = "open-web-calendar";
  version = "1.40";
  pyproject = true;

  disabled = python.pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "open_web_calendar";
    hash = "sha256-9BSyrnY+kLXyLiFmC9CSWdy3VZX/1kq2G+sIy2fIM0E=";
  };

  # The Pypi tarball doesn't contain open_web_calendars/features
  postPatch = ''
    ln -s $PWD/features open_web_calendar/features
    # https://github.com/niccokunzmann/open-web-calendar/pull/480
    substituteInPlace pyproject.toml \
      --replace "flask-allowedhosts" "flask-allowed-hosts"
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
