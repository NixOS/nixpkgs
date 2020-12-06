{ stdenv
, fetchurl
, intltool
, python3Packages
, gobject-introspection
, gtk3
, libwnck3
, keybinder3
, wrapGAppsHook
, wafHook
}:

with python3Packages;

buildPythonApplication rec {
  pname = "kupfer";
  version = "319";

  format = "other";

  src = fetchurl {
    url = "https://github.com/kupferlauncher/kupfer/releases/download/v${version}/kupfer-v${version}.tar.xz";
    sha256 = "0c9xjx13r8ckfr4az116bhxsd3pk78v04c3lz6lqhraak0rp4d92";
  };

  nativeBuildInputs = [
    wrapGAppsHook intltool
    # For setup hook
    gobject-introspection wafHook
  ];
  buildInputs = [ docutils libwnck3 keybinder3 ];
  propagatedBuildInputs = [ pygobject3 gtk3 pyxdg dbus-python pycairo ];

  # without strictDeps kupfer fails to build: Could not find the python module 'gi.repository.Gtk'
  # see https://github.com/NixOS/nixpkgs/issues/56943 for details
  strictDeps = false;

  postInstall = ''
    gappsWrapperArgs+=(
      "--prefix" "PYTHONPATH" : "${makePythonPath propagatedBuildInputs}"
      "--set" "PYTHONNOUSERSITE" "1"
    )
  '';

  doCheck = false; # no tests

  meta = with stdenv.lib; {
    description = "A smart, quick launcher";
    homepage    = "https://kupferlauncher.github.io/";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ cobbal ];
    platforms   = platforms.linux;
  };
}
