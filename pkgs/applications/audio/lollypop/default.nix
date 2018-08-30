{ stdenv, fetchgit, meson, ninja, pkgconfig, wrapGAppsHook
, appstream-glib, desktop-file-utils, gobjectIntrospection
, python36Packages, gnome3, glib, gst_all_1 }:

stdenv.mkDerivation rec  {
  version = "0.9.522";
  name = "lollypop-${version}";

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/lollypop";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "0f2brwv884cvmxj644jcj9sg5hix3wvnjy2ndg0fh5cxyqz0kwn5";
  };

  nativeBuildInputs = with python36Packages; [
    appstream-glib
    desktop-file-utils
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    wrapGAppsHook
    wrapPython
  ];

  buildInputs = [ glib ] ++ (with gnome3; [
    gsettings-desktop-schemas gtk3 libsecret libsoup totem-pl-parser
  ]) ++ (with gst_all_1; [
    gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly
    gstreamer
  ]);

  pythonPath = with python36Packages; [
    beautifulsoup4
    gst-python
    pillow
    pycairo
    pydbus
    pygobject3
    pylast
  ];

  postFixup = "wrapPythonPrograms";

  postPatch = ''
    chmod +x ./meson_post_install.py
    patchShebangs ./meson_post_install.py
  '';

  meta = with stdenv.lib; {
    description = "A modern music player for GNOME";
    homepage    = https://wiki.gnome.org/Apps/Lollypop;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.linux;
  };
}
