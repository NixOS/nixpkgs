{ stdenv, fetchgit, meson, ninja, pkgconfig
, python3, gtk3, libsecret, gst_all_1, webkitgtk
, glib-networking, gtkspell3, hunspell, desktop-file-utils
, gobjectIntrospection, wrapGAppsHook }:

python3.pkgs.buildPythonApplication rec {
  name = "eolie-${version}";
  version = "0.9.36";

  format = "other";
  doCheck = false;

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/eolie";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "1pqs6lddkj7nvxdwf0yncwdcr7683mpvx3912vn7b1f2q2zkp1fv";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    glib-networking
    gst-libav
    gst-plugins-base
    gst-plugins-ugly
    gstreamer
    gtk3
    gtkspell3
    hunspell
    libsecret
    webkitgtk
  ];

  pythonPath = with python3.pkgs; [
    beautifulsoup4
    pycairo
    pygobject3
    python-dateutil
  ];

  postPatch = ''
    chmod +x meson_post_install.py
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
