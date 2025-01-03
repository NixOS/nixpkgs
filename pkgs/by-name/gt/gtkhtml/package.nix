{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  gtk3,
  intltool,
  gnome,
  adwaita-icon-theme,
  enchant,
  isocodes,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation rec {
  pname = "gtkhtml";
  version = "4.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/${lib.versions.majorMinor version}/gtkhtml-${version}.tar.xz";
    sha256 = "ca3b6424fb2c7ac5d9cb8fdafb69318fa2e825c9cf6ed17d1e38d9b29e5606c3";
  };

  patches = [
    # Enables enchant2 support.
    # Upstream is dead, no further releases are coming.
    (fetchpatch {
      name = "enchant-2.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/enchant-2.patch?h=gtkhtml4&id=0218303a63d64c04d6483a6fe9bb55063fcfaa43";
      sha256 = "f0OToWGHZwxvqf+0qosfA9FfwJ/IXfjIPP5/WrcvArI=";
      extraPrefix = "";
    })
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gtkhtml"; };
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
  ];

  buildInputs = [
    gtk3
    adwaita-icon-theme
    gsettings-desktop-schemas
  ];

  propagatedBuildInputs = [
    enchant
    isocodes
  ];

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
