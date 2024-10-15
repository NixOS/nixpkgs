{ lib, stdenv, fetchFromGitHub, autoconf, automake, intltool, pkg-config,
gtk3, connman, openconnect, wrapGAppsHook3 }:

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
