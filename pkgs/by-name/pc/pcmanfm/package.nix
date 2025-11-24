{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  glib,
  intltool,
  libfm,
  libX11,
  pango,
  pkg-config,
  wrapGAppsHook3,
  adwaita-icon-theme,
  withGtk3 ? true,
  gtk2,
  gtk3,
  gettext,
  nix-update-script,
}:

let
  libfm' = libfm.override { inherit withGtk3; };
  gtk = if withGtk3 then gtk3 else gtk2;
  inherit (lib) optional;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pcmanfm";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "pcmanfm";
    tag = "${finalAttrs.version}";
    hash = "sha256-4kJDCnld//Vbe2KbrLoYZJ/dutagY/GImoOnbpQIdDY=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    intltool
    autoreconfHook
  ];

  buildInputs = [
    glib
    gtk
    libfm'
    libX11
    pango
    adwaita-icon-theme
  ];

  env.ACLOCAL = "aclocal -I ${gettext}/share/gettext/m4";

  configureFlags = optional withGtk3 "--with-gtk=3";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://blog.lxde.org/category/pcmanfm/";
    license = lib.licenses.gpl2Plus;
    description = "File manager with GTK interface";
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.linux;
    mainProgram = "pcmanfm";
  };
})
