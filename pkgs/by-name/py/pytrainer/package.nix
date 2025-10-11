{
  lib,
  python3,
  fetchFromGitHub,
  gdk-pixbuf,
  adwaita-icon-theme,
  gpsbabel,
  glib-networking,
  glibcLocales,
  gobject-introspection,
  gtk3,
  perl,
  sqlite,
  tzdata,
  webkitgtk_4_1,
  wrapGAppsHook3,
  xvfb-run,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = (
      self: super: {
        matplotlib = super.matplotlib.override {
          enableGtk3 = true;
        };
      }
    );
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "pytrainer";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytrainer";
    repo = "pytrainer";
    rev = "v${version}";
    hash = "sha256-t61vHVTKN5KsjrgbhzljB7UZdRask7qfYISd+++QbV0=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python.pkgs; [
    sqlalchemy
    python-dateutil
    matplotlib
    lxml
    requests
    gdal
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    sqlite
    gtk3
    webkitgtk_4_1
    glib-networking
    adwaita-icon-theme
    gdk-pixbuf
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      perl
      gpsbabel
    ])
  ];

  nativeCheckInputs = [
    glibcLocales
    perl
    xvfb-run
  ]
  ++ (with python.pkgs; [
    mysqlclient
    psycopg2
  ]);

  postPatch = ''
    substituteInPlace pytrainer/platform.py \
        --replace-fail 'sys.prefix' "\"$out\""

    # https://github.com/pytrainer/pytrainer/pull/281
    substituteInPlace pytrainer/extensions/mapviewer.py \
        --replace-fail "gi.require_version('WebKit2', '4.0')" "gi.require_version('WebKit2', '4.1')"
  '';

  checkPhase = ''
    env \
      HOME=$TEMPDIR \
      TZDIR=${tzdata}/share/zoneinfo \
      TZ=Europe/Kaliningrad \
      LC_TIME=C \
      xvfb-run -s '-screen 0 800x600x24' \
      ${python.interpreter} -m unittest
  '';

  meta = with lib; {
    # https://github.com/pytrainer/pytrainer/issues/280
    broken = true;
    homepage = "https://github.com/pytrainer/pytrainer";
    description = "Application for logging and graphing sporting excursions";
    mainProgram = "pytrainer";
    maintainers = with maintainers; [
      rycee
      dotlambda
    ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
