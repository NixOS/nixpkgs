{ stdenv, fetchgit, intltool, itstool, meson, ninja, pkgconfig, wrapGAppsHook
, git, glib, glib-networking, gsettings-desktop-schemas, gst_all_1, gtk3
, gtkspell3, libsecret, python36, python36Packages, webkitgtk }:

stdenv.mkDerivation rec {
  name = "eolie-${version}";
  version = "0.9.16";

  src = fetchgit {
    url = "https://gitlab.gnome.org/gnumdk/eolie";
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
  ];

  buildInputs = [
    git # required to download ad blocking DB
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

  enableParallelBuilding = true;

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  patches = [
    ./0001-Remove-post-install-script-handle-in-nix-config-inst.patch
    ./0001-Extend-the-python-path-rather-than-replacing-it.patch
  ];

  meta = with stdenv.lib; {
    description = "A new GNOME web browser";
    homepage = https://gitlab.gnome.org/gnumdk/eolie;
    license = licenses.gpl3;
    maintainers = [ maintainers.samdroid-apps ];
    platforms = platforms.linux;
  };
}
