{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  glib,
  intltool,
  libfm,
  libx11,
  pango,
  pkg-config,
  wrapGAppsHook3,
  adwaita-icon-theme,
  gtk3,
  gettext,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcmanfm";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "pcmanfm";
    tag = finalAttrs.version;
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
    gtk3
    libfm
    libx11
    pango
    adwaita-icon-theme
  ];

  env.ACLOCAL = "aclocal -I ${gettext}/share/gettext/m4";

  configureFlags = [ "--with-gtk=3" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://blog.lxde.org/category/pcmanfm/";
    license = lib.licenses.gpl2Plus;
    description = "File manager with GTK interface";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "pcmanfm";
  };
})
