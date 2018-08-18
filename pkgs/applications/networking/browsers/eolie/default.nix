{ stdenv, fetchgit, meson, ninja, pkgconfig, wrapGAppsHook
, desktop-file-utils, gobjectIntrospection, python36Packages
, gnome3, gst_all_1, gtkspell3, hunspell }:

stdenv.mkDerivation rec {
  name = "eolie-${version}";
  version = "0.9.35";

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/eolie";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "0x3p1fgx1fhrnr7vkkpnl34401r6k6xg2mrjff7ncb1k57q522k7";
  };

  nativeBuildInputs = with python36Packages; [
    desktop-file-utils
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    wrapGAppsHook
    wrapPython
  ];

  buildInputs = [ gtkspell3 hunspell python36Packages.pygobject3 ] ++ (with gnome3; [
    glib glib-networking gsettings-desktop-schemas gtk3 webkitgtk libsecret
  ]) ++ (with gst_all_1; [
    gst-libav gst-plugins-base gst-plugins-ugly gstreamer
  ]);

  pythonPath = with python36Packages; [
    beautifulsoup4
    pycairo
    pygobject3
    python-dateutil
  ];

  postFixup = "wrapPythonPrograms";

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A new GNOME web browser";
    homepage    = https://wiki.gnome.org/Apps/Eolie;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ samdroid-apps worldofpeace ];
    platforms   = platforms.linux;
  };
}
