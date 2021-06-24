{ lib
, fetchurl
, intltool
, python3Packages
, gobject-introspection
, gtk3
, itstool
, libwnck3
, keybinder3
, desktop-file-utils
, shared-mime-info
, wrapGAppsHook
, wafHook
}:

with python3Packages;

buildPythonApplication rec {
  pname = "kupfer";
  version = "321";

  format = "other";

  src = fetchurl {
    url = "https://github.com/kupferlauncher/kupfer/releases/download/v${version}/kupfer-v${version}.tar.bz2";
    sha256 = "0nagjp63gxkvsgzrpjk78cbqx9a7rbnjivj1avzb2fkhrlxa90c7";
  };

  nativeBuildInputs = [
    wrapGAppsHook intltool
    # For setup hook
    gobject-introspection wafHook
    itstool            # for help pages
    desktop-file-utils # for update-desktop-database
    shared-mime-info   # for update-mime-info
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

  meta = with lib; {
    description = "A smart, quick launcher";
    homepage    = "https://kupferlauncher.github.io/";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ cobbal ];
    platforms   = platforms.linux;
  };
}
