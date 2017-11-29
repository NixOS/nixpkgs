{ stdenv, unzip, fetchFromGitHub, pkgconfig, gtk3, vala, cmake, vte, libgee, wnck, gettext, libsecret, json_glib }:

stdenv.mkDerivation rec {
  name = "deepin-terminal-${version}";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-terminal";
    rev = version;
    sha256 = "11lylkrv69k2jvwparnxymr7z3x9cs82q9p0lr2wrfr48hnfwp8b";
  };

  patchPhase = ''
  substituteInPlace project_path.c --replace __FILE__ \"$out/share/deepin-terminal/\"
  '';

  nativeBuildInputs = [ pkgconfig vala cmake gettext unzip ];
  buildInputs = [ gtk3 vte libgee wnck libsecret json_glib ];

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
