{ stdenv, fetchgit, meson, ninja, pkgconfig
, python3, gtk3, gst_all_1, libsecret, libsoup
, appstream-glib, desktop-file-utils, totem-pl-parser
, hicolor-icon-theme, gobject-introspection, wrapGAppsHook }:

python3.pkgs.buildPythonApplication rec  {
  pname = "lollypop";
  version = "1.0";

  format = "other";
  doCheck = false;

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/lollypop";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "00hjxpgmhzhyjjdpm92cbbxwnc17xdhhk8svk5ih3n18yk5655fs";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    gobject-introspection
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk3
    hicolor-icon-theme
    libsecret
    libsoup
    totem-pl-parser
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    gst-python
    pillow
    pycairo
    pydbus
    pygobject3
    pylast
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    buildPythonPath "$out $propagatedBuildInputs"
    patchPythonScript "$out/libexec/lollypop-sp"
  '';

  meta = with stdenv.lib; {
    description = "A modern music player for GNOME";
    homepage = https://wiki.gnome.org/Apps/Lollypop;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
