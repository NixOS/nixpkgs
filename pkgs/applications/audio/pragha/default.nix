{
  lib,
  intltool,
  mkDerivation,
  installShellFiles,
  pkg-config,
  fetchFromGitHub,
  dbus-glib,
  desktop-file-utils,
  hicolor-icon-theme,
  qtbase,
  sqlite,
  taglib,
  zlib,
  gtk3,
  libpeas,
  libcddb,
  libcdio,
  gst_all_1,
  withGstPlugins ? true,
  glyr,
  withGlyr ? true,
  liblastfmSF,
  withLastfm ? true,
  libcdio-paranoia,
  withCD ? true,
  keybinder3,
  withKeybinder ? false,
  libnotify,
  withLibnotify ? false,
  libsoup_2_4,
  withLibsoup ? false,
  libgudev,
  withGudev ? false, # experimental
  libmtp,
  withMtp ? false, # experimental
  xfce,
  withXfce4ui ? false,
  totem-pl-parser,
  withTotemPlParser ? false,
# , grilo, withGrilo ? false
# , rygel, withRygel ? true
}:

assert withGlyr -> withLastfm;
assert withLastfm -> withCD;

mkDerivation rec {
  pname = "pragha";
  version = "1.3.99.1";

  src = fetchFromGitHub {
    owner = "pragha-music-player";
    repo = "pragha";
    rev = "v${version}";
    sha256 = "sha256-C4zh2NHqP4bwKMi5s+3AfEtKqxRlzL66H8OyNonGzxE=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
    xfce.xfce4-dev-tools
    desktop-file-utils
    installShellFiles
  ];

  buildInputs =
    with gst_all_1;
    [
      dbus-glib
      gstreamer
      gst-plugins-base
      gtk3
      hicolor-icon-theme
      libpeas
      qtbase
      sqlite
      taglib
      zlib
    ]
    ++ lib.optionals withGstPlugins [
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
    ]
    ++ lib.optionals withCD [
      libcddb
      libcdio
      libcdio-paranoia
    ]
    ++ lib.optional withGudev libgudev
    ++ lib.optional withKeybinder keybinder3
    ++ lib.optional withLibnotify libnotify
    ++ lib.optional withLastfm liblastfmSF
    ++ lib.optional withGlyr glyr
    ++ lib.optional withLibsoup libsoup_2_4
    ++ lib.optional withMtp libmtp
    ++ lib.optional withXfce4ui xfce.libxfce4ui
    ++ lib.optional withTotemPlParser totem-pl-parser
  # ++ lib.optional withGrilo grilo
  # ++ lib.optional withRygel rygel
  ;

  CFLAGS = [ "-DHAVE_PARANOIA_NEW_INCLUDES" ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev gst_all_1.gst-plugins-base}/include/gstreamer-1.0";

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")

    install -m 444 data/${pname}.desktop $out/share/applications
    install -d $out/share/pixmaps
    installManPage data/${pname}.1
  '';

  meta = with lib; {
    description = "Lightweight GTK+ music manager - fork of Consonance Music Manager";
    mainProgram = "pragha";
    homepage = "https://pragha-music-player.github.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mbaeten ];
    platforms = platforms.unix;
  };
}
