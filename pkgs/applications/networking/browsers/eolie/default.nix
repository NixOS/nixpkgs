{ stdenv, fetchgit, intltool, itstool, meson, ninja, pkgconfig, wrapGAppsHook
, glib, glib-networking, gsettings-desktop-schemas, gst_all_1, gtk3, gobjectIntrospection
, gtkspell3, libsecret, python36, python36Packages, webkitgtk }:

stdenv.mkDerivation rec {
  name = "eolie-${version}";
  version = "0.9.16";

  src = fetchgit {
    url = https://gitlab.gnome.org/gnumdk/eolie;
    rev = version;
    sha256 = "0mvhr6hy4nx7xaq9r9qp5rb0y293kjjryw5ykzb473cr3iwzk25b";
  };

  nativeBuildInputs = [
    intltool
    itstool
    meson
    ninja
    pkgconfig
    wrapGAppsHook
    gobjectIntrospection
  ];

  buildInputs = [
    glib
    glib-networking
    gsettings-desktop-schemas
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gtk3
    gtkspell3
    libsecret
    python36
    python36Packages.pygobject3
    python36Packages.pycairo
    python36Packages.dateutil
    python36Packages.dbus-python
    python36Packages.beautifulsoup4
    python36Packages.pycrypto
    python36Packages.requests
    webkitgtk
  ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  patches = [
    ./0001-Extend-the-python-path-rather-than-replacing-it.patch
  ];

  meta = with stdenv.lib; {
    description = "A new GNOME web browser";
    homepage = https://wiki.gnome.org/Apps/Eolie;
    license = licenses.gpl3;
    maintainers = [ maintainers.samdroid-apps ];
    platforms = platforms.linux;
  };
}
