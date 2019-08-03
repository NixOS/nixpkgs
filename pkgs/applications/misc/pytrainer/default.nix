{ stdenv
, fetchFromGitHub
, perl
, python3
, sqlite
, gpsbabel
, gnome3
, gobject-introspection
, wrapGAppsHook
, gtk3
, xvfb_run
, webkitgtk
, glib-networking
, glibcLocales
, tzdata
, substituteAll
}:

let
  # Pytrainer needs a matplotlib with GTK backend.
  matplotlibGtk = python3.pkgs.matplotlib.override {
    enableGtk3 = true;
  };

in

python3.pkgs.buildPythonApplication rec {
  pname = "pytrainer";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "pytrainer";
    repo = "pytrainer";
    rev = "v${version}";
    sha256 = "1w5z1xwb2g6j2izm89b7lv9n92r1zhsr8bglxcn7jc5gwbvwysvd";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      perl = "${perl}/bin/perl";
    })
  ];

  postPatch = ''
    substituteInPlace ./setup.py \
      --replace "'mysqlclient'," ""
  '';

  propagatedBuildInputs = with python3.pkgs; [
    dateutil
    lxml
    matplotlibGtk
    pygobject3
    sqlalchemy
    sqlalchemy_migrate
    psycopg2
    requests
    certifi
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
    xvfb_run
  ];

  buildInputs = [
    gpsbabel
    sqlite
    gtk3
    webkitgtk
    glib-networking
    glibcLocales
    gnome3.adwaita-icon-theme
  ];

  checkPhase = ''
    env HOME=$TEMPDIR TZDIR=${tzdata}/share/zoneinfo \
      TZ=Europe/Kaliningrad \
      LC_ALL=en_US.UTF-8 \
      xvfb-run -s '-screen 0 800x600x24' \
      ${python3.interpreter} setup.py test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pytrainer/pytrainer/wiki;
    description = "Application for logging and graphing sporting excursions";
    maintainers = [ maintainers.rycee ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
