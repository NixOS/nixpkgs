{
  lib,
  fetchFromGitLab,
  gettext,
  wrapGAppsHook4,

  # Native dependencies
  python3,
  gtk4,
  gobject-introspection,
  adwaita-icon-theme,
  gtksourceview5,
  glib-networking,
  libadwaita,

  # Optional dependencies
  enableJingle ? true,
  farstream,
  gstreamer,
  gst-plugins-base,
  gst-libav,
  gst-plugins-good,
  libnice,
  enableE2E ? true,
  enableSecrets ? true,
  libsecret,
  enableRST ? true,
  docutils,
  enableSpelling ? true,
  libspelling,
  enableUPnP ? true,
  gupnp-igd,
  enableAppIndicator ? true,
  libappindicator,
  enableSoundNotifications ? true,
  gsound,
  extraPythonPackages ? ps: [ ],
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gajim";
  version = "2.3.5";

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "gajim";
    tag = version;
    hash = "sha256-tYcb4CLzK6GNSrVxt2bpynWpnaEE3WZ1H22Lm4s3wRw=";
  };

  format = "pyproject";

  buildInputs = [
    gtk4
    adwaita-icon-theme
    gtksourceview5
    glib-networking
  ]
  ++ lib.optionals enableJingle [
    farstream
    gstreamer
    gst-plugins-base
    gst-libav
    gst-plugins-good
    libnice
  ]
  ++ lib.optional enableSecrets libsecret
  ++ lib.optional enableSpelling libspelling
  ++ lib.optional enableUPnP gupnp-igd
  ++ lib.optional enableAppIndicator libappindicator
  ++ lib.optional enableSoundNotifications gsound;

  nativeBuildInputs = [
    gettext
    wrapGAppsHook4
    gobject-introspection
    libadwaita
  ];

  dontWrapGApps = true;

  preBuild = ''
    python make.py build --dist unix
  '';

  postInstall = ''
    python make.py install --dist unix --prefix=$out
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  propagatedBuildInputs =
    with python3.pkgs;
    [
      nbxmpp
      dbus-python
      pillow
      css-parser
      precis-i18n
      keyring
      setuptools
      packaging
      gssapi
      omemo-dr
      qrcode
      sqlalchemy
      emoji

      gobject-introspection
      libadwaita
    ]
    ++ lib.optionals enableE2E [
      pycrypto
      python-gnupg
    ]
    ++ lib.optional enableRST docutils
    ++ extraPythonPackages python3.pkgs;

  nativeCheckInputs = [
    gobject-introspection
    libadwaita
  ];

  checkPhase = ''
    ${python3.interpreter} -m unittest discover -s test -v
  '';

  meta = {
    homepage = "http://gajim.org/";
    description = "Jabber client written in PyGTK";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
      hlad
    ];
    downloadPage = "http://gajim.org/download/";
    platforms = lib.platforms.linux;
    mainProgram = "gajim";
  };
}
