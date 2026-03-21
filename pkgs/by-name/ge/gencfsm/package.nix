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
  libsm,
  libice,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.9";
  pname = "gnome-encfs-manager";

  src = fetchurl {
    url =
      with lib.versions;
      "https://launchpad.net/gencfsm/trunk/${major finalAttrs.version}.${minor finalAttrs.version}/+download/gnome-encfs-manager_${finalAttrs.version}.tar.xz";
    sha256 = "RXVwg/xhfAQv3pWp3UylOhMKDh9ZACTuKM4lPrn1dk8=";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    # tools.c:38:5: error: implicit declaration of function 'gnome_encfs_manager_on_logout' []
    "-Wno-implicit-function-declaration"
  ];

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
    libsm
    libice
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

  meta = {
    homepage = "http://www.libertyzero.com/GEncfsM/";
    downloadPage = "https://launchpad.net/gencfsm/";
    description = "EncFS manager and mounter with GNOME3 integration";
    mainProgram = "gnome-encfs-manager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.spacefrogg ];
  };
})
