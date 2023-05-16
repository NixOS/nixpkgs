{ lib
, python310
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (old: rec {
        version = "1.4.46";
        src = self.fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-aRO4JH2KKS74MVFipRkx4rQM6RaB8bbxj2lwRSAMSjA=";
        };
      });
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    });
  };
in python.pkgs.buildPythonApplication rec {
  pname = "pytrainer";
<<<<<<< HEAD
  version = "2.2.1";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pytrainer";
    repo = "pytrainer";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-t61vHVTKN5KsjrgbhzljB7UZdRask7qfYISd+++QbV0=";
  };

  propagatedBuildInputs = with python.pkgs; [
    sqlalchemy
=======
    sha256 = "sha256-U2SVQKkr5HF7LB0WuCZ1xc7TljISjCNO26QUDGR+W/4=";
  };

  propagatedBuildInputs = with python.pkgs; [
    sqlalchemy-migrate
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
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
=======
  checkPhase = ''
    env HOME=$TEMPDIR TZDIR=${tzdata}/share/zoneinfo \
      TZ=Europe/Kaliningrad \
      LC_ALL=en_US.UTF-8 \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
