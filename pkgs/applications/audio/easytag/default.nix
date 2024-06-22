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
  taglib,
  libvorbis,
  libogg,
  opusfile,
  flac,
  itstool,
  libxml2,
  gsettings-desktop-schemas,
  gnome,
  wrapGAppsHook3,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "easytag";
  version = "2.4.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
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

  NIX_LDFLAGS = "-lid3tag -lz";

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
    taglib
    libvorbis
    libogg
    opusfile
    flac
    gsettings-desktop-schemas
    gnome.adwaita-icon-theme
  ];

  doCheck = false; # fails 1 out of 9 tests

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "View and edit tags for various audio files";
    mainProgram = "easytag";
    homepage = "https://gitlab.gnome.org/GNOME/easytag";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ matteopacini ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
