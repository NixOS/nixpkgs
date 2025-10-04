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

stdenv.mkDerivation rec {
  pname = "desktop-file-utils";
  version = "0.28";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-${version}.tar.xz";
    hash = "sha256-RAHU4jHYQsLegkI5WnSjlcpGjNlvX2ENgi3zNZSJinA=";
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

  postPatch = ''
    substituteInPlace src/install.c \
      --replace \"update-desktop-database\" \"$out/bin/update-desktop-database\"
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/desktop-file-utils";
    description = "Command line utilities for working with .desktop files";
    platforms = platforms.linux ++ platforms.darwin ++ platforms.freebsd;
    license = licenses.gpl2Plus;
  };
}
