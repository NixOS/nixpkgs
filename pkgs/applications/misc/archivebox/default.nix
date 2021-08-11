{ lib
, buildPythonApplication
, fetchPypi
, requests
, mypy-extensions
, django_3
, django_extensions
, dateparser
, youtube-dl
, python-crontab
, croniter
, w3lib
, ipython
}:

buildPythonApplication rec {
  pname = "archivebox";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zHty7lTra6yab9d0q3EqsPG3F+lrnZL6PjQAbL1A2NY=";
  };

  # Relax some dependencies
  postPatch = ''
    substituteInPlace setup.py --replace '"django>=3.1.3,<3.2"' '"django>=3.1.3"'
  '';

  propagatedBuildInputs = [
    requests
    mypy-extensions
    django_3
    django_extensions
    dateparser
    youtube-dl
    python-crontab
    croniter
    w3lib
    ipython
  ];

  meta = with lib; {
    description = "Open source self-hosted web archiving";
    homepage = "https://archivebox.io";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
