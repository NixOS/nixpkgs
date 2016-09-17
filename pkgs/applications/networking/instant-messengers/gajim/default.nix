{ stdenv, fetchurl, python, intltool, pkgconfig, libX11
, ldns, pythonPackages

, enableJingle ? true, farstream ? null, gst_plugins_bad ? null
,                      libnice ? null
, enableE2E ? true
, enableRST ? true
, enableSpelling ? true, gtkspell2 ? null
, enableNotifications ? false
, extraPythonPackages ? pkgs: []
}:

assert enableJingle -> farstream != null && gst_plugins_bad != null
                    && libnice != null;
assert enableE2E -> pythonPackages.pycrypto != null;
assert enableRST -> pythonPackages.docutils != null;
assert enableSpelling -> gtkspell2 != null;
assert enableNotifications -> pythonPackages.notify != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gajim-${version}";
  version = "0.16.5";

  src = fetchurl {
    url = "http://www.gajim.org/downloads/0.16/gajim-${version}.tar.bz2";
    sha256 = "14fhcqnkqygh91132dnf1idayj4r3iqbwb44sd3mxv20n6ribh55";
  };

  patches = [
    (fetchurl {
      name = "gajim-icon-index.patch";
      url = "http://hg.gajim.org/gajim/raw-rev/b9ec78663dfb";
      sha256 = "0w54hr5dq9y36val55kmh8d6cid7h4fs2nghx09714jylz2nyxxv";
    })
  ];

  postPatch = ''
    sed -i -e '0,/^[^#]/ {
      /^[^#]/i export \\\
        GST_PLUGIN_PATH="'"\$GST_PLUGIN_PATH''${GST_PLUGIN_PATH:+:}${""
        }$GST_PLUGIN_PATH"'"
    }' scripts/gajim.in

    sed -i -e 's/return helpers.is_in_path('"'"'drill.*/return True/' \
      src/features_window.py
    sed -i -e "s|'drill'|'${ldns}/bin/drill'|" src/common/resolver.py
  '' + optionalString enableSpelling ''
    sed -i -e 's|=.*find_lib.*|= "${gtkspell2}/lib/libgtkspell.so"|'   \
      src/gtkspell.py
  '';

  buildInputs = [
    python libX11
  ] ++ optionals enableJingle [ farstream gst_plugins_bad libnice ];

  nativeBuildInputs = [
    pythonPackages.wrapPython intltool pkgconfig
  ];

  propagatedBuildInputs = [
    pythonPackages.pygobject2 pythonPackages.pyGtkGlade
    pythonPackages.sqlite3 pythonPackages.pyasn1
    pythonPackages.pyxdg
    pythonPackages.nbxmpp
    pythonPackages.pyopenssl pythonPackages.dbus-python
  ] ++ optional enableE2E pythonPackages.pycrypto
    ++ optional enableRST pythonPackages.docutils
    ++ optional enableNotifications pythonPackages.notify
    ++ extraPythonPackages pythonPackages;

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
