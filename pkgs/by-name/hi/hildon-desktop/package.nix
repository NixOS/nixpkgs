{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  autoconf-archive,
  automake,
  pkg-config,
  glib,
  libtool,

  gnome2,
  dbus,
  xorg,
  libcanberra,
  gnome-menus,
  gdk-pixbuf-xlib,
  libmatchbox
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hildon-desktop";
  version = "2.2.194";

  src = fetchFromGitHub {
    owner = "maemo-leste";
    repo = "hildon-desktop";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-86ilVylbRUnSkm2Ujm580g3IfTDlKvkNB2nq/6hCNHU=";
  };

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    pkg-config
  ];

  buildInputs = [
    glib
    libtool
    # clutter # dont match clutter-0.8
    gnome2.GConf
    dbus
    libcanberra
    gnome-menus
    gdk-pixbuf-xlib
    libmatchbox
  ] ++ (with xorg; [
    libX11
    libXcomposite
    libXft
  ]);

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    maintainers = with lib.maintainers; [ simganificient ];
    license = lib.licenses.gpl2;
  };
})
