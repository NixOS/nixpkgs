{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  glib,
  libintl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "desktop-file-utils";
  version = "0.29";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-${finalAttrs.version}.tar.xz";
    hash = "sha256-Zh8iW+TGZ6vEli8HVxfbQlK2PIRID203smBQ0Cnaj6A=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    glib
    libintl
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace src/install.c \
      --replace-fail \"update-desktop-database\" \"$out/bin/update-desktop-database\"
  '';

  setupHook = ./setup-hook.sh;

  __structuredAttrs = true;

  meta = {
    homepage = "https://www.freedesktop.org/wiki/Software/desktop-file-utils";
    description = "Command line utilities for working with .desktop files";
    platforms = lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.freebsd;
    license = lib.licenses.gpl2Plus;
  };
})
