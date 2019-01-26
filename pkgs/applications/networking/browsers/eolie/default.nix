{ stdenv, fetchgit, meson, ninja, pkgconfig
, python3, gtk3, libsecret, gst_all_1, webkitgtk
, glib-networking, gtkspell3, hunspell, desktop-file-utils
, gobject-introspection, wrapGAppsHook }:

python3.pkgs.buildPythonApplication rec {
  pname = "eolie";
  version = "0.9.45";

  format = "other";
  doCheck = false;

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/eolie";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "0x6f2qqqxpjf28mqxs4jlrz2z8wa9nvb9h24nf8qwmzavjjbraqg";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
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

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    pycairo
    pygobject3
    python-dateutil
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    buildPythonPath "$out $propagatedBuildInputs"
    patchPythonScript "$out/libexec/eolie-sp"
  '';

  meta = with stdenv.lib; {
    description = "A new GNOME web browser";
    homepage = https://wiki.gnome.org/Apps/Eolie;
    license  = licenses.gpl3Plus;
    maintainers = with maintainers; [ samdroid-apps worldofpeace ];
    platforms = platforms.linux;
  };
}
