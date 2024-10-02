{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, glib
, dbus
, gettext
, cinnamon-desktop
, cinnamon-common
, intltool
, libxslt
, gtk3
, libgnomekbd
, caribou
, libtool
, wrapGAppsHook3
, gobject-introspection
, python3
, pam
, cairo
, xapp
, xdotool
, xorg
, iso-flags-png-320x240
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-screensaver";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-f1Z3fmtCokWNLJwsTOAIAZB3lwFfqakJJco3umyEaYk=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    gettext
    intltool
    dbus # for meson.build
    libxslt
    libtool
    meson
    ninja
    gobject-introspection
  ];

  buildInputs = [
    # from meson.build
    gtk3
    glib

    xorg.libXext
    xorg.libXinerama
    xorg.libX11
    xorg.libXrandr

    (python3.withPackages (pp: with pp; [
      pygobject3
      setproctitle
      python-xapp
      pycairo
    ]))
    xapp
    xdotool
    pam
    cairo
    cinnamon-desktop
    cinnamon-common
    libgnomekbd
    caribou
  ];

  postPatch = ''
    # cscreensaver hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i \
      -e s,/usr/share/locale,/run/current-system/sw/share/locale,g \
      -e s,/usr/lib/cinnamon-screensaver,$out/lib,g \
      -e s,/usr/share/cinnamon-screensaver,$out/share,g \
      -e s,/usr/share/iso-flag-png,${iso-flags-png-320x240}/share/iso-flags-png,g \
      {} +
  '';

  preFixup = ''
    # https://github.com/NixOS/nixpkgs/issues/101881
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${caribou}/share"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-screensaver";
    description = "Cinnamon screen locker and screensaver program";
    license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
