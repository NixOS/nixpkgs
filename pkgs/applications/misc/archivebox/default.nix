{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "archivebox";
  version = "0.6.2";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-zHty7lTra6yab9d0q3EqsPG3F+lrnZL6PjQAbL1A2NY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "django>=3.1.3,<3.2" "django<4"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    requests
    mypy-extensions
    django
    django-extensions
    dateparser
    youtube-dl
    python-crontab
    croniter
    w3lib
    ipython
  ];

  # TODO: implement tests
  doCheck = false;

  meta = with lib; {
    description = "Open source self-hosted web archiving";
    homepage = "https://archivebox.io";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
