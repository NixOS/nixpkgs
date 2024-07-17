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
}:

let
  pname = "easytag";
  version = "2.4.3";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1mbxnqrw1fwcgraa1bgik25vdzvf97vma5pzknbwbqq5ly9fwlgw";
  };

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
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
