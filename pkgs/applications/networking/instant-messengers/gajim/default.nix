{ lib, fetchurl, fetchFromGitLab, gettext, wrapGAppsHook

# Native dependencies
, python3, gtk3, gobject-introspection, gnome
, glib-networking

# Test dependencies
, xvfb-run, dbus

# Optional dependencies
, enableJingle ? true, farstream, gstreamer, gst-plugins-base, gst-libav, gst-plugins-good, libnice
, enableE2E ? true
, enableSecrets ? true, libsecret
, enableRST ? true, docutils
, enableSpelling ? true, gspell
, enableUPnP ? true, gupnp-igd
, enableOmemoPluginDependencies ? true
, enableAppIndicator ? true, libappindicator-gtk3
, extraPythonPackages ? ps: []
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gajim";
  version = "1.3.3";

  src = fetchurl {
    url = "https://gajim.org/downloads/${lib.versions.majorMinor version}/gajim-${version}.tar.gz";
    sha256 = "1337qkpcv7j0fgws9scnk82mn2l7s17060vmrbh3ihinmxmbxg6x";
  };

  buildInputs = [
    gobject-introspection gtk3 gnome.adwaita-icon-theme
    glib-networking
  ] ++ lib.optionals enableJingle [ farstream gstreamer gst-plugins-base gst-libav gst-plugins-good libnice ]
    ++ lib.optional enableSecrets libsecret
    ++ lib.optional enableSpelling gspell
    ++ lib.optional enableUPnP gupnp-igd
    ++ lib.optional enableAppIndicator libappindicator-gtk3;

  nativeBuildInputs = [
    gettext wrapGAppsHook
  ];

  # Workaround for https://dev.gajim.org/gajim/gajim/-/issues/10719.
  # We don't use plugin release URL because it's updated in place.
  plugins = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "gajim-plugins";
    rev = "fea522e4360cec6ceacbf1df92644ab3343d4b99";
    sha256 = "sha256-CmwEiLsdldoOfgHfWL/5hf/dp0HEDNAIlc5N0Np20KE=";
  };

  postPatch = ''
    mkdir -p gajim/data/plugins
    cp -r $plugins/plugin_installer gajim/data/plugins
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  propagatedBuildInputs = with python3.pkgs; [
    nbxmpp pygobject3 dbus-python pillow css-parser precis-i18n keyring setuptools
  ] ++ lib.optionals enableE2E [ pycrypto python-gnupg ]
    ++ lib.optional enableRST docutils
    ++ lib.optionals enableOmemoPluginDependencies [ python-axolotl qrcode ]
    ++ extraPythonPackages python3.pkgs;

  checkInputs = [ xvfb-run dbus.daemon ];

  checkPhase = ''
    xvfb-run dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      ${python3.interpreter} -m unittest discover -s test/unit -v
    ${python3.interpreter} -m unittest discover -s test/no_gui -v
  '';

  # necessary for wrapGAppsHook
  strictDeps = false;

  meta = {
    homepage = "http://gajim.org/";
    description = "Jabber client written in PyGTK";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ raskin abbradar ];
    downloadPage = "http://gajim.org/downloads.php";
    platforms = lib.platforms.linux;
  };
}
