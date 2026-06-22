{
  lib,
  fetchFromGitLab,
  gettext,
  wrapGAppsHook3,

  # Native dependencies
  python3,
  gtk4,
  gobject-introspection,
  adwaita-icon-theme,
  gtksourceview5,
  glib-networking,
  libadwaita,

  # Test dependencies
  xvfb-run,
  dbus,

  # Optional dependencies
  enableJingle ? true,
  farstream,
  gstreamer,
  gst-plugins-base,
  gst-libav,
  gst-plugins-good,
  libnice,
  enableSecrets ? true,
  libsecret,
  enableRST ? true,
  docutils,
  enableSpelling ? true,
  libspelling,
  enableUPnP ? true,
  gupnp-igd,
  enableAppIndicator ? true,
  libappindicator-gtk3,
  enableSoundNotifications ? true,
  gsound,
  extraPythonPackages ? ps: [ ],
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gajim";
  version = "2.4.7";

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "gajim";
    tag = version;
    hash = "sha256-tZ1+DRVCzwaWeur9mwc/zE34H2xdqk96upqWfqNTl3g=";
  };

  pyproject = true;

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
  ++ lib.optional enableAppIndicator libappindicator-gtk3
  ++ lib.optional enableSoundNotifications gsound;

  nativeBuildInputs = [
    gettext
    wrapGAppsHook3
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
      httpx
      h2
      truststore
      pysequoia
    ]
    ++ httpx.optional-dependencies.socks
    ++ lib.optional enableRST docutils
    ++ extraPythonPackages python3.pkgs;

  nativeCheckInputs = [
    xvfb-run
    dbus
  ];

  checkPhase = ''
    xvfb-run dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      ${python3.interpreter} -m unittest discover -s test/gui -v
    ${python3.interpreter} -m unittest discover -s test/common -v
  '';

  # test are broken in 1.7.3, 1.8.0
  doCheck = false;

  # necessary for wrapGAppsHook3
  strictDeps = false;

  meta = {
    homepage = "http://gajim.org/";
    description = "Jabber client written in PyGTK";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
      hlad
      vbgl
    ];
    downloadPage = "http://gajim.org/download/";
    platforms = lib.platforms.linux;
    mainProgram = "gajim";
  };
}
