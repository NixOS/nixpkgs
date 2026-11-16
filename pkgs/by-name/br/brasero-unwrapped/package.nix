{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gtk3,
  itstool,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  gst-libav,
  libxml2,
  libnotify,
  libcanberra-gtk3,
  intltool,
  dvdauthor,
  libburn,
  libisofs,
  vcdimager,
  wrapGAppsHook3,
  hicolor-icon-theme,
}:

let
  major = "3.12";
  minor = "3";
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
    hash = "sha256-h3SerjOhQSB9GwC+IzttgEWYLtMkntS5ja4fOpdf6hU=";
  };

  nativeBuildInputs = [
    pkg-config
    itstool
    intltool
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libxml2
    libnotify
    libcanberra-gtk3
    libburn
    libisofs
    hicolor-icon-theme
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ];

  # brasero checks that the applications it uses aren't symlinks, but this
  # will obviously not work on nix
  patches = [ ./remove-symlink-check.patch ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-girdir=$out/share/gir-1.0"
    "--with-typelibdir=$out/lib/girepository-1.0"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${binpath}")
  '';

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  meta = {
    description = "Gnome CD/DVD Burner";
    homepage = "https://gitlab.gnome.org/GNOME/brasero";
    maintainers = [ lib.maintainers.bdimcheff ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "brasero";
  };
})
