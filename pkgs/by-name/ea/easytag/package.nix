{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  gtk3,
  glib,
  libid3tag,
  id3lib,
  taglib_1,
  libvorbis,
  libogg,
  opusfile,
  flac,
  itstool,
  libxml2,
  gsettings-desktop-schemas,
  gnome,
  adwaita-icon-theme,
  wrapGAppsHook3,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "easytag";
  version = "2.4.3";

  src = fetchurl {
    url = "mirror://gnome/sources/easytag/${lib.versions.majorMinor version}/easytag-${version}.tar.xz";
    hash = "sha256-/FHukqcF48WXnf8WVfdJbv+2i5jxraBUfoy7wDO2fdU=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/easytag/-/merge_requests/8
    # Borrowed from Gentoo
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-sound/easytag/files/easytag-2.4.3-ogg-corruption.patch?id=b175a159c1138702bdfb009ff4d6565019ed3c4a";
      hash = "sha256-z75dYTEVp1raSFROjpakLeBjF96sgWBxxRB6ut9wYXw=";
    })
  ];

  env = {
    NIX_LDFLAGS = "-lid3tag -lz";
    # Note: this allows id3lib to be found at configure time, and also prevents
    # compilation errors on Linux (GCC 15). Clang / Darwin seems to be unaffected.
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=c17 -Wno-implicit-function-declaration";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    itstool
    libxml2
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3
    glib
    libid3tag
    id3lib
    taglib_1
    libvorbis
    libogg
    opusfile
    flac
    gsettings-desktop-schemas
    adwaita-icon-theme
  ];

  doCheck = false; # fails 1 out of 9 tests

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = {
    description = "View and edit tags for various audio files";
    mainProgram = "easytag";
    homepage = "https://gitlab.gnome.org/GNOME/easytag";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
