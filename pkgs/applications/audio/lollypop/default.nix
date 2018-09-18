{ stdenv, fetchgit, meson, ninja, pkgconfig
, python3, gtk3, gst_all_1, libsecret, libsoup
, appstream-glib, desktop-file-utils, gnome3
, gobjectIntrospection, wrapGAppsHook }:

python3.pkgs.buildPythonApplication rec  {
  version = "0.9.522";
  name = "lollypop-${version}";

  format = "other";
  doCheck = false;

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/lollypop";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "0f2brwv884cvmxj644jcj9sg5hix3wvnjy2ndg0fh5cxyqz0kwn5";
  };

  nativeBuildInputs = with python3.pkgs; [
    appstream-glib
    desktop-file-utils
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    gnome3.totem-pl-parser
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk3
    libsecret
    libsoup
  ];

  pythonPath = with python3.pkgs; [
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
    buildPythonPath "$out/libexec/lollypop-sp $pythonPath"
    patchPythonScript "$out/libexec/lollypop-sp"
  '';

  meta = with stdenv.lib; {
    description = "A modern music player for GNOME";
    homepage    = https://wiki.gnome.org/Apps/Lollypop;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.linux;
  };
}
