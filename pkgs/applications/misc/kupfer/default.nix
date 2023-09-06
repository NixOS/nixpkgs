{ lib
, fetchurl
, intltool
, python3Packages
, gobject-introspection
, gtk3
, itstool
, libwnck
, keybinder3
, desktop-file-utils
, shared-mime-info
, wrapGAppsHook
, waf
, bash
, dbus
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
    gobject-introspection waf.hook
    itstool            # for help pages
    desktop-file-utils # for update-desktop-database
    shared-mime-info   # for update-mime-info
    docutils # for rst2man
    dbus # for detection of dbus-send during build
  ];
  buildInputs = [ libwnck keybinder3 bash ];
  propagatedBuildInputs = [ pygobject3 gtk3 pyxdg dbus-python pycairo ];

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
