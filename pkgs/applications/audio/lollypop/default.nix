{ lib
, fetchgit
, meson
, ninja
, pkgconfig
, python3
, gtk3
, gst_all_1
, libsecret
, libsoup
, appstream-glib
, desktop-file-utils
, totem-pl-parser
, hicolor-icon-theme
, gobject-introspection
, wrapGAppsHook
, lastFMSupport ? true
, wikipediaSupport ? true
, youtubeSupport ? true, youtube-dl
}:

python3.pkgs.buildPythonApplication rec  {
  pname = "lollypop";
  version = "1.0.12";

  format = "other";
  doCheck = false;

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/lollypop";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "0jc40p2yw3zp035c87crav2lq0iraf35ag9w26vzmbjvgpvwzb86";
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
    libsoup
    totem-pl-parser
  ] ++ lib.optional lastFMSupport libsecret;

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    pillow
    pycairo
    pygobject3
  ]
  ++ lib.optional lastFMSupport pylast
  ++ lib.optional wikipediaSupport wikipedia
  ++ lib.optional youtubeSupport youtube-dl
  ;

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    buildPythonPath "$out $propagatedBuildInputs"
    patchPythonScript "$out/libexec/lollypop-sp"
  '';

  meta = with lib; {
    description = "A modern music player for GNOME";
    homepage = https://wiki.gnome.org/Apps/Lollypop;
    license = licenses.gpl3Plus;
    changelog = "https://gitlab.gnome.org/World/lollypop/tags/${version}";
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
