{
  lib,
  python3Packages,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  intltool,
  pandoc,
  pkg-config,
  wrapGAppsHook3,
  gobject-introspection,
  glib,
  libsoup_3,
  systemd,
}:
python3Packages.buildPythonApplication {
  pname = "slimpris2";
  version = "4.0.2";
  pyproject = false;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mavit";
    repo = "slimpris2";
    tag = "4.0.2";
    hash = "sha256-ho3iFWW+qj+nwPlY8VIvqZ9NBI95Cuosk4ibXvp1XYA=";
  };

  postPatch = ''
    sed -i '/AC_OUTPUT/i \
    AC_CONFIG_MACRO_DIRS([m4])\
    AM_GNU_GETTEXT_VERSION([0.21])\
    AM_GNU_GETTEXT([external])' configure.ac
  '';

  preConfigure = ''
    intltoolize -f
  '';

  nativeBuildInputs = [
    autoreconfHook
    gettext
    intltool
    pandoc
    pkg-config
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    glib
    libsoup_3
    systemd
  ];

  dependencies = with python3Packages; [
    dbus-python
    pygobject3
    pyxdg
    simplejson
    six
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-systemduserunitdir=$(out)/share/systemd/user"
    "--with-systemduserpresetdir=$(out)/etc/systemd/user"
  ];

  meta = {
    description = "MPRIS 2 remote control for Lyrion Music Server (Squeezebox)";
    homepage = "https://github.com/mavit/slimpris2";
    license = lib.licenses.gpl3Only;
    mainProgram = "slimpris2";
    maintainers = with lib.maintainers; [ ser ];
    platforms = lib.platforms.linux;
  };
}
