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
  xdotool,
  libxrandr,
  libxinerama,
  libxext,
  libx11,
  iso-flags-png-320x240,
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-screensaver";
  version = "6.6.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-screensaver";
    tag = version;
    hash = "sha256-NK33cIrcTicLs59eJ550FghjuWS93yD642ObAS55Dtk=";
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

    libxext
    libxinerama
    libx11
    libxrandr

    (python3.withPackages (
      pp: with pp; [
        pygobject3
        setproctitle
        python-xapp
        pycairo
      ]
    ))
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

  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-screensaver";
    description = "Cinnamon screen locker and screensaver program";
    license = [
      lib.licenses.gpl2
      lib.licenses.lgpl2
    ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}
