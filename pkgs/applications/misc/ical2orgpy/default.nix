{ lib
, buildPythonApplication
, fetchFromGitHub
, pytestCheckHook
, pbr
, git
, click
, future
, icalendar
, pytz
, tzlocal
, recurring-ical-events
, freezegun
, pyyaml
}:

buildPythonApplication rec {
  pname = "ical2orgpy";
  version = "0.4";

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  src = fetchFromGitHub {
    owner = "ical2org-py";
    repo = "ical2org.py";
    rev = "${version}";
    sha256 = "1swvxrnicbs42lbaw415s2wj41bn30lkf4gvhhln5iq7mccygw2a";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    pbr
    git
  ];

  propagatedBuildInputs = [
    click
    future
    icalendar
    pytz
    tzlocal
    recurring-ical-events
  ];

  checkInputs = [
    pytestCheckHook
    freezegun
    pyyaml
  ];

}
