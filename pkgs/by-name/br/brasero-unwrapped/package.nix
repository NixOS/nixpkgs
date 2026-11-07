{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gtk3,
  shared-mime-info,
  desktop-file-utils,
  itstool,
  appstream,
  gst_all_1,
  libxml2,
  libnotify,
  libcanberra-gtk3,
  intltool,
  dvdauthor,
  libburn,
  libisofs,
  vcdimager,
  totem-pl-parser,
  tinysparql,
  wrapGAppsHook3,
  hicolor-icon-theme,
}:

let
  major = "3.12";
  minor = "4";
  binpath = lib.makeBinPath [
    dvdauthor
    vcdimager
  ];

in
stdenv.mkDerivation (finalAttrs: {
  version = "${major}.${minor}";
  pname = "brasero";

  src = fetchurl {
    url = "mirror://gnome/sources/brasero/${major}/brasero-${finalAttrs.version}.tar.xz";
    hash = "sha256-MiYEmsQJaQk8V1b5iS5229oe/rEFzaMvOf1S9lR+1bM=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    shared-mime-info
    desktop-file-utils
    itstool
    appstream
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libxml2
    libnotify
    libcanberra-gtk3
    libburn
    libisofs
    totem-pl-parser
    tinysparql
    hicolor-icon-theme
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

  # brasero checks that the applications it uses aren't symlinks, but this
  # will obviously not work on nix
  patches = [ ./remove-symlink-check.patch ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${binpath}")
  '';

  meta = {
    description = "Gnome CD/DVD Burner";
    homepage = "https://gitlab.gnome.org/GNOME/brasero";
    maintainers = [
      lib.maintainers.bdimcheff
      lib.maintainers.juliusfreudenberger
    ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "brasero";
  };
})
