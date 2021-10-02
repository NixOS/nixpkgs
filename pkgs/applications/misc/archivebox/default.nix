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

let
  django_3' = django_3.overridePythonAttrs (old: rec {
    pname = "Django";
    version = "3.1.7";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Ms55Lum2oMu+w0ASPiKayfdl3/jCpK6SR6FLK6OjZac=";
    };
  });
in

buildPythonApplication rec {
  pname = "archivebox";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zHty7lTra6yab9d0q3EqsPG3F+lrnZL6PjQAbL1A2NY=";
  };

  propagatedBuildInputs = [
    requests
    mypy-extensions
    django_3'
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
