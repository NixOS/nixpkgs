{ lib
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_3.overridePythonAttrs (old: rec {
        version = "3.1.7";
        src = old.src.override {
          inherit version;
          sha256 = "sha256-Ms55Lum2oMu+w0ASPiKayfdl3/jCpK6SR6FLK6OjZac=";
        };
      });
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "archivebox";
  version = "0.6.2";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-zHty7lTra6yab9d0q3EqsPG3F+lrnZL6PjQAbL1A2NY=";
  };

  propagatedBuildInputs = with python.pkgs; [
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

  meta = with lib; {
    description = "Open source self-hosted web archiving";
    homepage = "https://archivebox.io";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
