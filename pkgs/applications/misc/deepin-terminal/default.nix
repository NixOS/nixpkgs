{ stdenv, unzip, fetchFromGitHub, pkgconfig, gtk3, vala, cmake, vte, gee, wnck, gettext, libsecret, json_glib }:

stdenv.mkDerivation rec {
  name = "deepin-terminal-${version}";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-terminal";
    rev = version;
    sha256 = "0qam34g1rannv8kvw1zbps763a9ii9vbrkxyxxdk737hlpxdzg8h";
  };

  patchPhase = ''
  substituteInPlace project_path.c --replace __FILE__ \"$out/share/deepin-terminal/\"
  '';
  buildInputs = [ unzip gtk3 pkgconfig vala cmake vte gee wnck gettext libsecret json_glib ];

  meta = {
    description = "The default terminal emulation for Deepin";
    longDescription = ''
        Deepin terminal, it sharpens your focus in the world of command line!
        It is an advanced terminal emulator with workspace, multiple windows, remote management, quake mode and other features.
     '';
    homepage = https://github.com/linuxdeepin/deepin-terminal/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
