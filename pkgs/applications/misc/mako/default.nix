{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, scdoc
, systemd, pango, cairo, gdk-pixbuf
, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "mako";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hwvibpnrximb628w9dsfjpi30b5jy7nfkm4d94z5vhp78p43vxh";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc wayland-protocols ];
  buildInputs = [ systemd pango cairo gdk-pixbuf wayland ];

  mesonFlags = [ "-Dzsh-completions=true" ];

  meta = with stdenv.lib; {
    description = "A lightweight Wayland notification daemon";
    homepage = https://wayland.emersion.fr/mako/;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir synthetica ];
    platforms = platforms.linux;
  };
}
