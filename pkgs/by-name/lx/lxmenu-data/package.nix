{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  intltool,
  pkg-config,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxmenu-data";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxmenu-data";
    tag = finalAttrs.version;
    hash = "sha256-5QdQ+7nzj7wDrfdt4GT8VW4+sHgZdE7h3cReY2pmcak=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
    glib
  ];

  meta = {
    homepage = "https://lxde.org/";
    license = lib.licenses.gpl2;
    description = "Freedesktop.org desktop menus for LXDE";
    platforms = lib.platforms.linux;
  };
})
