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

  # Optional dependencies
  enableJingle ? true,
  farstream,
  gst_all_1,
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
  libappindicator,
  enableSoundNotifications ? true,
  gsound,
  extraPythonPackages ? ps: [ ],
}:
let
  inherit (gst_all_1)
    gstreamer
    gst-plugins-base
    gst-libav
    gst-plugins-good
    ;
in
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gajim";
  version = "2.6.0";

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "gajim";
    tag = finalAttrs.version;
    hash = "sha256-VxsfHZvS3m+j/xcd9BFcNZactAzG8kBdv1jDnkCghV4=";
  };

  pyproject = true;

  buildInputs = [
    gtk4
    adwaita-icon-theme
    gtksourceview5
    glib-networking
    gstreamer
    gst-plugins-base
  ]
  ++ lib.optionals enableJingle [
    farstream
    gst-libav
    (gst-plugins-good.override { gtkSupport = true; })
    libnice
  ]
  ++ lib.optional enableSecrets libsecret
  ++ lib.optional enableSpelling libspelling
  ++ lib.optional enableUPnP gupnp-igd
  ++ lib.optional enableAppIndicator libappindicator
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
    python3.pkgs.pytestCheckHook
  ];

  # necessary for wrapGAppsHook3
  strictDeps = false;

  meta = {
    homepage = "http://gajim.org/";
    description = "XMPP chat client";
    longDescription = "Gajim aims to be an easy to use and fully-featured XMPP client. Just chat with your friends or family, easily share pictures and thoughts or discuss the news with your groups.";
    changelog = "https://dev.gajim.org/gajim/gajim/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
      hlad
      vbgl
      haansn08
    ];
    donationPage = "https://liberapay.com/Gajim";
    downloadPage = "http://gajim.org/download/";
    platforms = lib.platforms.linux;
    mainProgram = "gajim";
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "gajim" finalAttrs.version;
  };
})
