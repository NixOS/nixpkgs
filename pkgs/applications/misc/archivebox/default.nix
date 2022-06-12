{ lib
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      django = super.django_3.overridePythonAttrs (old: rec {
        version = "3.1.14";
        src = old.src.override {
          inherit version;
          sha256 = "72a4a5a136a214c39cf016ccdd6b69e2aa08c7479c66d93f3a9b5e4bb9d8a347";
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
