{ lib
, fetchFromGitLab
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, gtk3
, gst_all_1
, libhandy
, libsecret
, libsoup_3
, appstream-glib
, desktop-file-utils
, totem-pl-parser
, gobject-introspection
, glib-networking
, gdk-pixbuf
, glib
, pango
, wrapGAppsHook
, lastFMSupport ? true
, youtubeSupport ? true
}:

python3.pkgs.buildPythonApplication rec  {
  pname = "lollypop";
  version = "1.4.37";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-3GPmGNbbSxvLq0t3F9q1x64BwNQCEvFQWLb0bSO9KUY=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    gdk-pixbuf
    glib
    glib-networking
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk3
    libhandy
    libsoup_3
    pango
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

  postFixup = ''
    wrapPythonProgramsIn $out/libexec "$out $propagatedBuildInputs"
  '';

  strictDeps = false;

  # Produce only one wrapper using wrap-python passing
  # gappsWrapperArgs to wrap-python additional wrapper
  # argument
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    changelog = "https://gitlab.gnome.org/World/lollypop/tags/${version}";
    description = "A modern music player for GNOME";
    homepage = "https://wiki.gnome.org/Apps/Lollypop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
    mainProgram = "lollypop";
  };
}
