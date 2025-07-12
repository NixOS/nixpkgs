{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoconf,
  automake,
  intltool,
  pkg-config,
  gtk3,
  connman,
  openconnect,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "connman-gtk";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jgke";
    repo = "connman-gtk";
    rev = "v${version}";
    hash = "sha256-2bfoGXzy4wXRALLXEEa7vPWbsBNUhE31nn7dDkuHYCY=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    openconnect
    connman
  ];

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/nickm/connman-gtk/-/raw/ef01b52fa02c5cca199b2e47c0cf360691266fd8/debian/patches/incompatible-pointer-type";
      hash = "sha256-T+N9FfDyROBA4/HLK+l/fpnju2imDU4y6nGSbF+JDiA=";
    })
  ];

  preConfigure = ''
    # m4/intltool.m4 is an invalid symbolic link
    rm m4/intltool.m4
    ln -s ${intltool}/share/aclocal/intltool.m4 m4/
    ./autogen.sh
  '';

  meta = with lib; {
    description = "GTK GUI for Connman";
    mainProgram = "connman-gtk";
    homepage = "https://github.com/jgke/connman-gtk";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
