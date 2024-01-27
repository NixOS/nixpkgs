{ lib
, python310
, fetchPypi
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
  python = python310.override {
    packageOverrides = (self: super: {
      matplotlib = super.matplotlib.override {
        enableGtk3 = true;
      };
    });
  };
in python.pkgs.buildPythonApplication rec {
  pname = "pytrainer";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "pytrainer";
    repo = "pytrainer";
    rev = "v${version}";
    hash = "sha256-t61vHVTKN5KsjrgbhzljB7UZdRask7qfYISd+++QbV0=";
  };

  propagatedBuildInputs = with python.pkgs; [
    sqlalchemy
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

  nativeCheckInputs = [
    glibcLocales
    perl
    xvfb-run
  ] ++ (with python.pkgs; [
    mysqlclient
    psycopg2
  ]);

  postPatch = ''
    substituteInPlace pytrainer/platform.py \
        --replace 'sys.prefix' "\"$out\""
  '';

  checkPhase = ''
    env \
      HOME=$TEMPDIR \
      TZDIR=${tzdata}/share/zoneinfo \
      TZ=Europe/Kaliningrad \
      LC_TIME=C \
      xvfb-run -s '-screen 0 800x600x24' \
      ${python.interpreter} setup.py test
  '';

  meta = with lib; {
    homepage = "https://github.com/pytrainer/pytrainer";
    description = "Application for logging and graphing sporting excursions";
    maintainers = with maintainers; [ rycee dotlambda ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
