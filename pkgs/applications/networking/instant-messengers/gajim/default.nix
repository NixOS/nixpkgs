{ buildPythonApplication, lib, fetchurl, gettext, wrapGAppsHook
, python, gtk3, gobjectIntrospection
, nbxmpp, pyasn1, pygobject3, gnome3, dbus-python, pillow
, xvfb_run, dbus
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
  majorVersion = "0.16";
  version = "${majorVersion}.9";

  src = fetchurl {
    url = "https://gajim.org/downloads/${majorVersion}/gajim-${version}.tar.bz2";
    sha256 = "16ynws10vhx6rhjjjmzw6iyb3hc19823xhx4gsb14hrc7l8vzd1c";
  };

  # Needed for Plugin Installer
  release = fetchurl {
    url = "https://gajim.org/downloads/${majorVersion}/gajim-${version}.tar.bz2";
    sha256 = "0v08zdvpqaig0wxpxn1l8rsj3wr3fqvnagn8cnvch17vfqv9gcr1";
  };

  postUnpack = ''
    tar -xaf $release
    cp -r ${name}/plugins/plugin_installer gajim-${name}-*/plugins
    rm -rf ${name}
  '';

  patches = let
    # An attribute set of revisions to apply from the upstream repository.
    cherries = {
      #example-fix = {
      #  rev = "<replace-with-git-revsion>";
      #  sha256 = "<replace-with-sha256>";
      #};
    };
  in (mapAttrsToList (name: { rev, sha256 }: fetchurl {
    name = "gajim-${name}.patch";
    url = "https://dev.gajim.org/gajim/gajim/commit/${rev}.diff";
    inherit sha256;
  }) cherries);

  postPatch = ''
    # This test requires network access
    echo "" > test/integration/test_resolver.py
  '';

  buildInputs = [
    gobjectIntrospection gtk3 gnome3.defaultIconTheme
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

  checkInputs = [ xvfb_run dbus.daemon ];

  checkPhase = ''
    xvfb-run dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      ${python.interpreter} test/runtests.py
  '';

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
