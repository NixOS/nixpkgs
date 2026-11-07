{
  lib,
  stdenv,
  fetchFromGitLab,
  gnome-common,
  intltool,
  libarchive,
  gdk-pixbuf,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-kra-ora-thumbnailer";
  version = "1.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gnome-kra-ora-thumbnailer";
    tag = finalAttrs.version;
    hash = "sha256-zyEX8vOn8Gdt3B8sx3oXcRUpm2h2use4CUKsWqaqbaw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    intltool
    autoreconfHook
    pkg-config
    gnome-common
  ];

  buildInputs = [
    libarchive
    gdk-pixbuf
  ];

  meta = {
    description = "Thumbnailer for Krita and MyPaint images";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-kra-ora-thumbnailer/-/blob/${finalAttrs.src.tag}?ref_type=tags";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-kra-ora-thumbnailer/-/blob/${finalAttrs.src.tag}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.linux;
  };
})
