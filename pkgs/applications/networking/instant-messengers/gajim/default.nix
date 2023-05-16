{ lib, fetchurl, fetchFromGitLab, gettext, wrapGAppsHook

# Native dependencies
, python3, gtk3, gobject-introspection, gnome
, gtksourceview4
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
<<<<<<< HEAD
=======
, enableOmemoPluginDependencies ? true
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, enableAppIndicator ? true, libappindicator-gtk3
, extraPythonPackages ? ps: []
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gajim";
<<<<<<< HEAD
  version = "1.8.1";

  src = fetchurl {
    url = "https://gajim.org/downloads/${lib.versions.majorMinor version}/gajim-${version}.tar.gz";
    hash = "sha256-Erh7tR6WX8pt89PRicgbVZd8CLlv18Vyq44O+ZnJVzU=";
  };

  format = "pyproject";

  buildInputs = [
    gtk3 gnome.adwaita-icon-theme
=======
  version = "1.6.1";

  src = fetchurl {
    url = "https://gajim.org/downloads/${lib.versions.majorMinor version}/gajim-${version}.tar.gz";
    hash = "sha256-3D87Ou/842WqbaUiJV1hRZFVkZzQ12GXCpRc8F3rKPQ=";
  };

  buildInputs = [
    gobject-introspection gtk3 gnome.adwaita-icon-theme
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    gtksourceview4
    glib-networking
  ] ++ lib.optionals enableJingle [ farstream gstreamer gst-plugins-base gst-libav gst-plugins-good libnice ]
    ++ lib.optional enableSecrets libsecret
    ++ lib.optional enableSpelling gspell
    ++ lib.optional enableUPnP gupnp-igd
    ++ lib.optional enableAppIndicator libappindicator-gtk3;

  nativeBuildInputs = [
<<<<<<< HEAD
    gettext wrapGAppsHook gobject-introspection
=======
    gettext wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  propagatedBuildInputs = with python3.pkgs; [
    nbxmpp pygobject3 dbus-python pillow css-parser precis-i18n keyring setuptools packaging gssapi
<<<<<<< HEAD
    omemo-dr qrcode
  ] ++ lib.optionals enableE2E [ pycrypto python-gnupg ]
    ++ lib.optional enableRST docutils
=======
  ] ++ lib.optionals enableE2E [ pycrypto python-gnupg ]
    ++ lib.optional enableRST docutils
    ++ lib.optionals enableOmemoPluginDependencies [ python-axolotl qrcode ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ extraPythonPackages python3.pkgs;

  nativeCheckInputs = [ xvfb-run dbus ];

<<<<<<< HEAD
  preBuild = ''
    python pep517build/build_metadata.py -o dist/metadata
  '';

  postInstall = ''
    python pep517build/install_metadata.py dist/metadata --prefix=$out
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkPhase = ''
    xvfb-run dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      ${python3.interpreter} -m unittest discover -s test/gui -v
    ${python3.interpreter} -m unittest discover -s test/common -v
  '';

<<<<<<< HEAD
  # test are broken in 1.7.3, 1.8.0
  doCheck = false;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # necessary for wrapGAppsHook
  strictDeps = false;

  meta = {
    homepage = "http://gajim.org/";
    description = "Jabber client written in PyGTK";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ raskin abbradar ];
    downloadPage = "http://gajim.org/download/";
    platforms = lib.platforms.linux;
  };
}
