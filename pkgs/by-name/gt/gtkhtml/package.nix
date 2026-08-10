{
  lib,
  stdenv,
  fetchurl,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkhtml";
  version = "4.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/${lib.versions.majorMinor finalAttrs.version}/gtkhtml-${finalAttrs.version}.tar.xz";
    hash = "sha256-yjtkJPssesXZy4/a+2kxj6LoJcnPbtF9HjjZsp5WBsM=";
  };

  patches = [
    # Enables enchant2 support.
    # Upstream is dead, no further releases are coming.
    # Vendored from https://aur.archlinux.org/cgit/aur.git/plain/enchant-2.patch?h=gtkhtml4&id=0218303a63d64c04d6483a6fe9bb55063fcfaa43
    ./enchant-2.patch
    # Resolves a GCC14 missing typecast error
    ./typecast.diff
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

  meta = {
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
