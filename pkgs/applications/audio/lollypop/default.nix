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
, youtubeSupport ? true
}:

python3.pkgs.buildPythonApplication rec  {
  pname = "lollypop";
  version = "1.1.4.14";

  format = "other";
  doCheck = false;

  src = fetchgit {
    url = "https://gitlab.gnome.org/World/lollypop";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    sha256 = "004cwbnxss6vmdsc6i0y83h3xbc2bzc0ra4z99pkizkky2mz6swj";
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

  # Produce only one wrapper using wrap-python passing
  # gappsWrapperArgs to wrap-python additional wrapper
  # argument
  dontWrapGApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
  ];

  meta = with lib; {
    description = "A modern music player for GNOME";
    homepage = https://wiki.gnome.org/Apps/Lollypop;
    license = licenses.gpl3Plus;
    changelog = "https://gitlab.gnome.org/World/lollypop/tags/${version}";
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
