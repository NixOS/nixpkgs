{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  gettext,
  glib,
  gobject-introspection,
  intltool,
  libnotify,
  python3Packages,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "mpDris2";
  version = "0.9.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "eonpatapon";
    repo = "mpDris2";
    tag = version;
    hash = "sha256-1Y6K3z8afUXeKhZzeiaEF3yqU0Ef7qdAj9vAkRlD2p8=";
  };

  preConfigure = ''
    intltoolize -f
  '';

  nativeBuildInputs = [
    autoreconfHook
    gettext
    gobject-introspection
    intltool
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    libnotify
  ];

  dependencies = with python3Packages; [
    dbus-python
    mpd2
    mutagen
    pygobject3
  ];

  # Python builder already uses makeWrapper, so we disable the hook
  # and add its args to the existing ones for Python:
  # https://nixos.org/manual/nixpkgs/stable/#ssec-gnome-common-issues-double-wrapped
  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  patches = [ ./fix-gettext-0.25.patch ];

  meta = {
    description = "MPRIS 2 support for mpd";
    homepage = "https://github.com/eonpatapon/mpDris2/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "mpDris2";
  };
}
