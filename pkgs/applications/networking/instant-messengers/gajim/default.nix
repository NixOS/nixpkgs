{ stdenv, fetchurl, autoreconfHook, python, intltool, pkgconfig, libX11
, ldns, pythonPackages

# Test requirements
, xvfb_run

, enableJingle ? true, farstream ? null, gst-plugins-bad ? null
,                      libnice ? null
, enableE2E ? true
, enableRST ? true
, enableSpelling ? true, gtkspell2 ? null
, enableNotifications ? false
, enableOmemoPluginDependencies ? true
, extraPythonPackages ? pkgs: []
}:

assert enableJingle -> farstream != null && gst-plugins-bad != null
                    && libnice != null;
assert enableE2E -> pythonPackages.pycrypto != null;
assert enableRST -> pythonPackages.docutils != null;
assert enableSpelling -> gtkspell2 != null;
assert enableNotifications -> pythonPackages.notify != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gajim-${version}";
  version = "0.16.6";

  src = fetchurl {
    name = "${name}.tar.bz2";
    url = "https://dev.gajim.org/gajim/gajim/repository/archive.tar.bz2?"
        + "ref=${name}";
    sha256 = "1s0h4xll9490vh7ygmi4zsd1fa107f3s9ykhpq0snb04fllwhjq7";
  };

  patches = let
    # An attribute set of revisions to apply from the upstream repository.
    cherries = {
      misc-test-fixes = {
        rev = "1f0d7387fd020df5dfc9a6349005ec7dedb7c008";
        sha256 = "0nazpzyg50kl0k8z4dkn033933iz60g1i6nzhib1nmzhwwbnacc5";
      };
      jingle-fix = {
        rev = "491d32a2ec13ed3a482e151e0b403eda7b4151b8";
        sha256 = "1pfg1ysr0p6rcwmd8ikjs38av3c4gcxn8pxr6cnnj27n85gvi30g";
      };
      fix-connection-mock = {
        rev = "46a19733d208fbd2404cbaeedd8c203d0b6557a4";
        sha256 = "0l3s577pksnz16r4mqa1zmz4y165amsx2mclrm4vzlszy35rmy2b";
      };
    };
  in mapAttrsToList (name: { rev, sha256 }: fetchurl {
    name = "gajim-${name}.patch";
    url = "https://dev.gajim.org/gajim/gajim/commit/${rev}.diff";
    inherit sha256;
  }) cherries;

  postPatch = ''
    sed -i -e '0,/^[^#]/ {
      /^[^#]/i export \\\
        GST_PLUGIN_PATH="'"\$GST_PLUGIN_PATH''${GST_PLUGIN_PATH:+:}${""
        }$GST_PLUGIN_PATH"'"
    }' scripts/gajim.in

    # requires network access
    echo "" > test/integration/test_resolver.py

    # We want to run tests in installCheckPhase rather than checkPhase to test
    # whether the *installed* version of Gajim works rather than just whether it
    # works in the unpacked source tree.
    sed -i -e '/sys\.path\.insert.*gajim_root.*\/src/d' test/lib/__init__.py
  '' + optionalString enableSpelling ''
    sed -i -e 's|=.*find_lib.*|= "${gtkspell2}/lib/libgtkspell.so"|'   \
      src/gtkspell.py
  '';

  buildInputs = [
    python libX11
  ] ++ optionals enableJingle [ farstream gst-plugins-bad libnice ];

  nativeBuildInputs = [
    autoreconfHook pythonPackages.wrapPython intltool pkgconfig
    # Test dependencies
    xvfb_run
  ];

  autoreconfPhase = ''
    sed -e 's/which/type -P/;s,\./configure,:,' autogen.sh | bash
  '';

  propagatedBuildInputs = with pythonPackages; [
    libasyncns
    pygobject2 pyGtkGlade
    pyasn1
    pyxdg
    nbxmpp
    pyopenssl dbus-python
  ] ++ optional enableE2E pythonPackages.pycrypto
    ++ optional enableRST pythonPackages.docutils
    ++ optional enableNotifications pythonPackages.notify
    ++ optionals enableOmemoPluginDependencies (with pythonPackages; [
      cryptography python-axolotl python-axolotl-curve25519 qrcode
    ]) ++ extraPythonPackages pythonPackages;

  postFixup = ''
    install -m 644 -t "$out/share/gajim/icons/hicolor" \
                      "icons/hicolor/index.theme"

    buildPythonPath "$out"

    for i in $out/bin/*; do
      name="$(basename "$i")"
      if [ "$name" = "gajim-history-manager" ]; then
        name="history_manager"
      fi

      patchPythonScript "$out/share/gajim/src/$name.py"
    done
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    XDG_DATA_DIRS="$out/share/gajim''${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS" \
    PYTHONPATH="test:$out/share/gajim/src:''${PYTHONPATH:+:}$PYTHONPATH" \
      xvfb-run make test
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://gajim.org/";
    description = "Jabber client written in PyGTK";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.raskin maintainers.aszlig ];
    downloadPage = "http://gajim.org/downloads.php";
    updateWalker = true;
    platforms = stdenv.lib.platforms.linux;
  };
}
