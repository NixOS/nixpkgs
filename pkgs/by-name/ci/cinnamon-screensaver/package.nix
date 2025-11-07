{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  glib,
  dbus,
  gettext,
  cinnamon-desktop,
  cinnamon,
  intltool,
  libxslt,
  gtk3,
  libgnomekbd,
  caribou,
  libtool,
  wrapGAppsHook3,
  gobject-introspection,
  python3,
  pam,
  cairo,
  xapp,
  xdotool,
  xorg,
  iso-flags-png-320x240,
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-screensaver";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-screensaver";
    tag = version;
    hash = "sha256-CK4WP5IafNII81e8HxUNN3Vp36Ln78Xvv5lIMvL+nbk=";
  };

  patches = [
    # Do not override GI_TYPELIB_PATH set by wrapGAppsHook3.
    # https://github.com/linuxmint/cinnamon-screensaver/pull/456#discussion_r1702738776.
    ./preserve-existing-gi-typelib-path.patch
  ];

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

    (python3.withPackages (
      pp: with pp; [
        pygobject3
        setproctitle
        python-xapp
        pycairo
      ]
    ))
    xapp
    xdotool
    pam
    cairo
    cinnamon-desktop
    cinnamon
    libgnomekbd
    caribou
  ];

  postPatch = ''
    # cscreensaver hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i \
      -e s,/usr/share/locale,/run/current-system/sw/share/locale,g \
      -e s,/usr/share/iso-flag-png,${iso-flags-png-320x240}/share/iso-flags-png,g \
      {} +
  '';

  preFixup = ''
    # https://github.com/NixOS/nixpkgs/issues/101881
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${caribou}/share"
    )
  '';

  postFixup = ''
    # Shared objects can't be wrapped.
    mv $out/libexec/cinnamon-screensaver/{.libcscreensaver.so-wrapped,libcscreensaver.so}
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-screensaver";
    description = "Cinnamon screen locker and screensaver program";
    license = [
      licenses.gpl2
      licenses.lgpl2
    ];
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
