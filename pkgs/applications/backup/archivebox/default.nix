{ lib, stdenv, fetchFromGitHub, python3Packages, }:

python3Packages.buildPythonApplication rec {
  pname = "archivebox";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ArchiveBox";
    repo = "ArchiveBox";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-x9UIy8fg8Ya8eBQX9IxUe0yprEY8eez9Im+/0/4rJz8=";
  };

  prePatch = ''
    substituteInPlace setup.py --replace 'django>=3.1.3,<3.2' 'django>=3.1.3'
  '';

  propagatedBuildInputs = with python3Packages; [
    croniter
    dateparser
    django_3
    django_extensions
    ipython
    mypy-extensions
    python-crontab
    requests
    w3lib
    youtube-dl
  ];

  meta = with lib; {
    homepage = "https://archivebox.io/";
    description = "Open-source self-hosted web archiving";
    license = licenses.mit;
    maintainers = with maintainers; [ vojta001 ];
  };
}
