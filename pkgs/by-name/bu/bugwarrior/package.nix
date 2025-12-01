{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "bugwarrior";
  version = "2.0.0";
  pyproject = true;
  disabled = python3Packages.pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-blTKtNfhTZyJHwIOq1P7HjtEmNnz/bL6dWr402veNm4=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.setuptools
    python3Packages.twiggy
    python3Packages.requests
    python3Packages.offtrac
    python3Packages.python-bugzilla
    python3Packages.taskw
    python3Packages.python-dateutil
    python3Packages.pytz
    python3Packages.keyring
    python3Packages.six
    python3Packages.jinja2
    python3Packages.pycurl
    python3Packages.dogpile-cache
    python3Packages.lockfile
    python3Packages.click
    python3Packages.pyxdg
    python3Packages.jira
    python3Packages.pydantic
    python3Packages.tomli
  ];

  # for the moment oauth2client <4.0.0 and megaplan>=1.4 are missing for running the test suite.
  doCheck = false;

  meta = {
    homepage = "https://github.com/GothenburgBitFactory/bugwarrior";
    description = "Sync github, bitbucket, bugzilla, and trac issues with taskwarrior";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.pierron ];
  };
}
