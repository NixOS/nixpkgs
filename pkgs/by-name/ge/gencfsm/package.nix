{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  intltool,
  libtool,
  pkg-config,
  encfs,
  libsecret,
  glib,
  libgee,
  gtk3,
  vala,
  wrapGAppsHook3,
  xorg,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  version = "1.9";
  pname = "gnome-encfs-manager";

  src = fetchurl {
    url =
      with lib.versions;
      "https://launchpad.net/gencfsm/trunk/${major version}.${minor version}/+download/gnome-encfs-manager_${version}.tar.xz";
    sha256 = "RXVwg/xhfAQv3pWp3UylOhMKDh9ZACTuKM4lPrn1dk8=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    libtool
    pkg-config
    vala
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs = [
    glib
    encfs
    gtk3
    libgee
    xorg.libSM
    xorg.libICE
    libsecret
  ];

  # Fix hardcoded paths to /bin/mkdir
  patches = [ ./makefile-mkdir.patch ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--disable-appindicator" ];

  preFixup = "gappsWrapperArgs+=(--prefix PATH : ${encfs}/bin)";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.libertyzero.com/GEncfsM/";
    downloadPage = "https://launchpad.net/gencfsm/";
    description = "EncFS manager and mounter with GNOME3 integration";
    mainProgram = "gnome-encfs-manager";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.spacefrogg ];
  };
}
