{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Fix startup crash with SQLAlchemy 2.0
    (fetchpatch {
      url = "https://github.com/pytrainer/pytrainer/commit/9847c76e61945466775bde038057bf5fd31ae089.patch";
      hash = "sha256-cGNu4lK0eQWzcSFTKc8g/qHSSHfy0ow4T3eT+zl5lPM=";
    })

    # Port to webkigtk 4.1
    (fetchpatch {
      url = "https://github.com/pytrainer/pytrainer/commit/eda968a8b48074f03efbdfbd692b46edef3658cd.patch";
      hash = "sha256-MdxsKO6DgncHhGlJWcEeyYiPKf3qdhMqXrYYC+jqros=";
    })
  ];

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
