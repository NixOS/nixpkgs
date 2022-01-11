{ lib
, python3
, fetchFromGitHub
, gdk-pixbuf
, gnome
, gpsbabel
, glib-networking
, glibcLocales
, gobject-introspection
, gtk3
, perl
, sqlite
, tzdata
, webkitgtk
, wrapGAppsHook
, xvfb-run
}:

let
  python = python3.override {
    packageOverrides = (self: super: {
      matplotlib = super.matplotlib.override {
        enableGtk3 = true;
      };
    });
  };
in python.pkgs.buildPythonApplication rec {
  pname = "pytrainer";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "pytrainer";
    repo = "pytrainer";
    rev = "v${version}";
    sha256 = "sha256-i3QC6ct7tS8B0QQjtVqPcd03LLIxo6djQe4YX35syzk=";
  };

  propagatedBuildInputs = with python.pkgs; [
    sqlalchemy-migrate
    python-dateutil
    matplotlib
    lxml
    setuptools
    requests
    gdal
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    sqlite
    gtk3
    webkitgtk
    glib-networking
    gnome.adwaita-icon-theme
    gdk-pixbuf
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ perl gpsbabel ])
  ];

  checkInputs = [
    glibcLocales
    perl
    xvfb-run
  ] ++ (with python.pkgs; [
    mysqlclient
    psycopg2
  ]);

  checkPhase = ''
    env HOME=$TEMPDIR TZDIR=${tzdata}/share/zoneinfo \
      TZ=Europe/Kaliningrad \
      LC_ALL=en_US.UTF-8 \
      xvfb-run -s '-screen 0 800x600x24' \
      ${python3.interpreter} setup.py test
  '';

  meta = with lib; {
    homepage = "https://github.com/pytrainer/pytrainer";
    description = "Application for logging and graphing sporting excursions";
    maintainers = with maintainers; [ rycee dotlambda ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
