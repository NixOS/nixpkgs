{ lib, fetchurl, gettext, wrapGAppsHook

# Native dependencies
, python3, gtk3, gobject-introspection, gnome3

# Test dependencies
, xvfb_run, dbus

# Optional dependencies
, enableJingle ? true, farstream, gstreamer, gst-plugins-base, gst-libav, gst-plugins-ugly, libnice
, enableE2E ? true
, enableSecrets ? true, libsecret
, enableRST ? true, docutils
, enableSpelling ? true, gspell
, enableUPnP ? true, gupnp-igd
, enableOmemoPluginDependencies ? true
, extraPythonPackages ? ps: []
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gajim";
  majorVersion = "1.1";
  version = "${majorVersion}.3";

  src = fetchurl {
    url = "https://gajim.org/downloads/${majorVersion}/gajim-${version}.tar.bz2";
    sha256 = "0bzxwcpdd4ydh6d6mzpr0gxwhcb0x9ympk55fpvm1hcw9d28a716";
  };

  postPatch = ''
    # This test requires network access
    echo "" > test/integration/test_resolver.py
  '';

  buildInputs = [
    gobject-introspection gtk3 gnome3.adwaita-icon-theme wrapGAppsHook
  ] ++ lib.optionals enableJingle [ farstream gstreamer gst-plugins-base gst-libav gst-plugins-ugly libnice ]
    ++ lib.optional enableSecrets libsecret
    ++ lib.optional enableSpelling gspell
    ++ lib.optional enableUPnP gupnp-igd;

  nativeBuildInputs = [
    gettext
  ];

  propagatedBuildInputs = with python3.pkgs; [
    nbxmpp pyasn1 pygobject3 dbus-python pillow cssutils precis-i18n keyring setuptools
  ] ++ lib.optionals enableE2E [ pycrypto python-gnupg ]
    ++ lib.optional enableRST docutils
    ++ lib.optionals enableOmemoPluginDependencies [ python-axolotl qrcode ]
    ++ extraPythonPackages python3.pkgs;

  checkInputs = [ xvfb_run dbus.daemon ];

  checkPhase = ''
    xvfb-run dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      ${python3.interpreter} setup.py test
  '';

  meta = {
    homepage = http://gajim.org/;
    description = "Jabber client written in PyGTK";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ raskin aszlig abbradar ];
    downloadPage = "http://gajim.org/downloads.php";
    updateWalker = true;
    platforms = lib.platforms.linux;
  };
}
