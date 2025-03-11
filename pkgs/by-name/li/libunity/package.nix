{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  glib,
  vala,
  dee,
  gobject-introspection,
  libdbusmenu,
  gtk3,
  intltool,
  python3,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "libunity";
  version = "unstable-2021-02-01";

  outputs = [
    "out"
    "dev"
    "py"
  ];

  # Obtained from https://git.launchpad.net/ubuntu/+source/libunity/log/
  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/libunity";
    rev = "import/7.1.4+19.04.20190319-5";
    sha256 = "LHUs6kl1srS6Xektx+jmm4SXLR47VuQ9IhYbBxf2Wc8=";
  };

  patches = [
    # Fix builf with latest Vala
    # https://code.launchpad.net/~jtojnar/libunity/libunity
    # Did not send upstream because Ubuntu is stuck on Vala 0.48.
    ./fix-vala.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    gobject-introspection
    intltool
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    glib
    gtk3
  ];

  propagatedBuildInputs = [
    dee
    libdbusmenu
  ];

  preConfigure = ''
    intltoolize
  '';

  configureFlags = [
    "--with-pygi-overrides-dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  meta = with lib; {
    description = "Library for instrumenting and integrating with all aspects of the Unity shell";
    homepage = "https://launchpad.net/libunity";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
