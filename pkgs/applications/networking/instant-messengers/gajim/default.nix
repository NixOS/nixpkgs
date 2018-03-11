{ stdenv, fetchurl, autoreconfHook, python, intltool, pkgconfig, libX11
, ldns, pythonPackages

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
  majorVersion = "0.16";
  version = "${majorVersion}.9";

  src = fetchurl {
    name = "${name}.tar.bz2";
    url = "https://dev.gajim.org/gajim/gajim/repository/archive.tar.bz2?"
        + "ref=${name}";
    sha256 = "121dh906zya9n7npyk7b5xama0z3ycy9jl7l5jm39pc86h1winh3";
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
    PYTHONPATH="test:$out/share/gajim/src:''${PYTHONPATH:+:}$PYTHONPATH" \
      make test_nogui
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://gajim.org/;
    description = "Jabber client written in PyGTK";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.raskin maintainers.aszlig ];
    downloadPage = "http://gajim.org/downloads.php";
    updateWalker = true;
    platforms = stdenv.lib.platforms.linux;
  };
}
