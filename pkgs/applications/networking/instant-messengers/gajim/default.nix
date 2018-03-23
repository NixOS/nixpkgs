{ buildPythonApplication, lib, fetchurl, gettext, wrapGAppsHook
, python, gtk3, gobjectIntrospection
, nbxmpp, pyasn1, pygobject3, dbus-python, pillow
, enableJingle ? true, farstream, gstreamer, gst-plugins-base, gst-libav, gst-plugins-ugly
, enableE2E ? true, pycrypto, python-gnupg
, enableSecrets ? true, libsecret
, enableRST ? true, docutils
, enableSpelling ? true, gspell
, enableUPnP ? true, gupnp-igd
, enableOmemoPluginDependencies ? true, python-axolotl, qrcode
, extraPythonPackages ? pkgs: [], pythonPackages
}:

with lib;

buildPythonApplication rec {
  name = "gajim-${version}";
  majorVersion = "1.0";
  version = "${majorVersion}.0";

  src = fetchurl {
    url = "https://gajim.org/downloads/${majorVersion}/gajim-${version}.tar.bz2";
    sha256 = "10da4imfldj04917h54vrmg70a1d832jd8p6386paa5jqzf5qk20";
  };

  buildInputs = [
    gobjectIntrospection gtk3
  ] ++ optionals enableJingle [ farstream gstreamer gst-plugins-base gst-libav gst-plugins-ugly ]
    ++ optional enableSecrets libsecret
    ++ optional enableSpelling gspell
    ++ optional enableUPnP gupnp-igd;

  nativeBuildInputs = [
    gettext wrapGAppsHook
  ];

  propagatedBuildInputs = [
    nbxmpp pyasn1 pygobject3 dbus-python pillow
  ] ++ optionals enableE2E [ pycrypto python-gnupg ]
    ++ optional enableRST docutils
    ++ optionals enableOmemoPluginDependencies [ python-axolotl qrcode ]
    ++ extraPythonPackages pythonPackages;

  checkPhase = ''
    ${python.interpreter} test/runtests.py
  '';

  # Tests try to use GTK+ which fails.
  doCheck = false;

  meta = {
    homepage = http://gajim.org/;
    description = "Jabber client written in PyGTK";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin aszlig abbradar ];
    downloadPage = "http://gajim.org/downloads.php";
    updateWalker = true;
    platforms = platforms.linux;
  };
}
