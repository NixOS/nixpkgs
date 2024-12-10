{
  lib,
  fetchurl,
  fetchFromGitLab,
  gettext,
  wrapGAppsHook3,

  # Native dependencies
  python3,
  gtk3,
  gobject-introspection,
  gnome,
  gtksourceview4,
  glib-networking,

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
  enableE2E ? true,
  enableSecrets ? true,
  libsecret,
  enableRST ? true,
  docutils,
  enableSpelling ? true,
  gspell,
  enableUPnP ? true,
  gupnp-igd,
  enableAppIndicator ? true,
  libappindicator-gtk3,
  extraPythonPackages ? ps: [ ],
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gajim";
  version = "1.9.3";

  src = fetchurl {
    url = "https://gajim.org/downloads/${lib.versions.majorMinor version}/gajim-${version}.tar.gz";
    hash = "sha256-TxWyUDoBvscKa2ogPrFlzLC2q+5RMyMnAiOpQdpFP4M=";
  };

  format = "pyproject";

  buildInputs =
    [
      gtk3
      gnome.adwaita-icon-theme
      gtksourceview4
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
    ++ lib.optional enableSpelling gspell
    ++ lib.optional enableUPnP gupnp-igd
    ++ lib.optional enableAppIndicator libappindicator-gtk3;

  nativeBuildInputs = [
    gettext
    wrapGAppsHook3
    gobject-introspection
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  propagatedBuildInputs =
    with python3.pkgs;
    [
      nbxmpp
      pygobject3
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
    ]
    ++ lib.optionals enableE2E [
      pycrypto
      python-gnupg
    ]
    ++ lib.optional enableRST docutils
    ++ extraPythonPackages python3.pkgs;

  nativeCheckInputs = [
    xvfb-run
    dbus
  ];

  preBuild = ''
    python pep517build/build_metadata.py -o dist/metadata
  '';

  postInstall = ''
    python pep517build/install_metadata.py dist/metadata --prefix=$out
  '';

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
      abbradar
    ];
    downloadPage = "http://gajim.org/download/";
    platforms = lib.platforms.linux;
    mainProgram = "gajim";
  };
}
